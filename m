Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab2GBUsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:48:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab2GBUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:48:49 -0400
Date: Mon, 2 Jul 2012 22:48:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Charkov <alchark@gmail.com>
Subject: Re: [PATCH v2 3/3] pwm: Convert pwm-vt8500 to use devm_* APIs
Message-ID: <20120702204839.GA16327@avionic-0098.mockup.avionic-design.de>
References: <1341102443.3712.0.camel@phoenix>
 <1341102568.3712.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1341102568.3712.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IQkGWq47IIDlk9LkpRf4CMBKQUInt3K76hchoAdAZrt
 b8s1kXbiqTuxNUlwepR+ZgE056xlclaYUbiM/y8DsJQfd1HpfA
 1VgGvBmGDJuKe/qEX+J60zxBOgskFMNGFdoZG2GyN8G3v3AYCa
 5/TvAVv4/XDO2hOpeIJ9b71VR6d3wYyBt8zxOtMhphjYkpcTxj
 HunA1+YA2zgMWo54/g7wl/o0jvoGxkjKfV53s6AevCoYD861Wi
 CnX1zT1CMNnRxDgCTX0Z07fmLN4/IKJzhasUnPWNygULfrQQij
 0A8fH7OjysRoV7tIUmhSZuLK/RIgijEOLoNm9xc+ZvbnhswsIC
 CNQu4nwT58OMGm/BN89rqBvuTWakx2neTzcbkSY6PIqlE93Dnv
 vZxjsO2UPbwkX6bU4MzCeq2tHFNMqp92Un2Qpzmax8VdrUwiCi
 V4EuJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 08:29:28AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-vt8500.c |   47 ++++++++--------------------------------------
>  1 file changed, 8 insertions(+), 39 deletions(-)

Applied, thanks.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8gknAAoJEN0jrNd/PrOhYLUP/0ahyu2ZirBRkj6G/aL8g3Zx
w68+lDq7zw8TIYSxOl86XovEWhp5xSX0ueM6GKcQsFwdxEH/epfn+AXYaaPh3b4w
h7NTMP4IAYypXK8NVv5tW+JyxxE/IXkfCd8uDotl4pH95DfJDKvFOJxpzdfyD0dK
QyaYi/yezgvjWYPvIJtiHW7p02p6MSmVOb5XGAkzb8P+mJd/JyKaoFcl73JgK281
kkzIDIB1f8eMN8HpeP4HMj4uhCSTBDRwYGClWyooLUwJOGTl7L6LagHJKgtomTpK
kyqMdR22qFztok5QPvA/g6dJ34HwXEoRiQcIlTle4/9+rqx6W1egKyu9DTs9Jyb8
ZROyfzKqeR54ZRpNNM5HAQ4cZDpnxDdNlOQIM36QTf9UK8PwqeELIPwNmyiHMyNI
FkR/Z68sNZz1eSENy3SGppQOZRv5yibV/HwPUL0+qn/6XeciCqIGw0iFeWJy/5xo
pDbqML1uvSx+Pa8JxXZyDo7EXDEFyZo35Sm4V4xdUvqgMBWvSWQyvge/xrmewc8j
GtFpnpSDIeabrdNLfmTCK20XoRCcvFpeX+sozDMgndYnVyuWcGQNpcG+pHuArCZg
r/TpHqqmFAVnEu2vQGl+B4DOpSXo+eVm/FPzEjEUgnsxYS8rdZBg0fBMUF6at9Pw
NP+dayH36ueb3DO1r3cn
=ZLKG
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
