Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2DDWYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:24:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59660 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab2DDWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:24:07 -0400
Date: Wed, 4 Apr 2012 23:24:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 6/6] regmap: prevent division by zero in rbtree_show
Message-ID: <20120404222400.GG10787@opensource.wolfsonmicro.com>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
 <1333576113-13196-6-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Content-Disposition: inline
In-Reply-To: <1333576113-13196-6-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 03:48:33PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> If there are no nodes in the cache, nodes will be 0, so calculating
> "registers / nodes" will cause division by zero.

Applied, thanks.  I'm not sure what this patch was generated against,
git am can't seem to find the blobs referenced.

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfMn5AAoJEBus8iNuMP3doqcP/1++qs5BGpCG2l93dehGksjw
ubRFGk10kvuh6oS+vdQI/ZkLylZ9+X+YOvRp4tVPskXDkiFt8PLw+TZ/logMH4nd
OJfi7uOpfdlyvmmWwhlS1WZ+n5xEdBw1tCnAf7p7ckdiyMKMSzgjIi2xBgMQ6rzh
zUS2NNu9ZVEmGrUrThqzaNONcdz2FBpLyz/GCUoFWEnosyI5fxANLMtpivpXQa0k
W5nUNfkzjpSBGbO4S1knZL39pKxhWAnUaTmU9TjmRNHi7VgkAwzA2hgUQVZGrGFY
6mgAUeRGX4AMTphgSUUwb3xPAzNKS7Eo4B18EmyeXLAS8xcbd/EWtjOUcmG/ibdy
bkPXpNak3tcc2qhpPp+KaIoW8VAA56172ZJbs0gE646fe9aqLVikCEq1dEMj/W80
wlxp9pBRYxFUyBr7WrJac891N8F18B5Z0RigUo9v5J72jS/HEfzqbnPPiTtQuRO4
cIdDdzEdcEN8nBFCitbl1j6kON94nmaTOaihstGj7uvYsjCLCwkPScXtu16gSwnA
Q8phpZKe4DmBNLvr2kLDSM/VA49jQAwxJ0yqFPzv40joy5Ga2HtCNMmtDzUpiA39
kcG/Z6ythaJoCbiLHC9u1THs4kTYYAWOiV2S80gnGc8qg3YNVouDXQmDiXiTZAuY
h7nOXaV0z8HS0gDYYUlz
=oj8b
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
