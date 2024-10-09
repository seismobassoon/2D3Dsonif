using Images, FileIO, Glob, Sound

using LinearAlgebra


# The goal is not to sonify my cat (she talks a lot anyways)
# but I am looking for an elegant way of sonifying images that is robust 
#
# Can we "hear" the signatures of dogs and cats and dynamic models?

directory = "./artemis"
files=glob("*.jpeg",directory)

images=[]
numberImages=length(files)
for i in 1:numberImages
    push!(images,float(load(files[i])))
end
img=images[1]
channels = channelview(img)

function rank_approx(F::SVD, k)
    U, S, V = F
    M = U[:, 1:k] * Diagonal(S[1:k]) * V[:, 1:k]'
    clamp01!(M)
end

svdfactors = svd.(eachslice(channels; dims=1))
imgs = map((1,2,3,4,5,6,7,8)) do k
    colorview(RGB, rank_approx.(svdfactors, k)...)
end

mosaicview(img, imgs...; nrow=4, npad=10)

# I was thinking about sonifying each eigenvector 
# with different octave for example but this SVD
# is sensitive to the angle of the image.
# Someone can help me...
