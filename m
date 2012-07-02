Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2GBU6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:58:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2GBU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:58:03 -0400
Date: Mon, 2 Jul 2012 22:57:54 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 3/4] pwm: Convert pwm-samsung to use devm_* APIs
Message-ID: <20120702205754.GA29849@avionic-0098.mockup.avionic-design.de>
References: <1340976628.4752.0.camel@phoenix>
 <1340976735.4752.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1340976735.4752.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:j9ReIkRW3uFnyf7Ev53MqXPIdS8gJ6G7jqkjs9nUYei
 UegnxgPj1pTzNzOp3epvQuhC+XJrvPsVW5KU6C8FA0D7y8O/yP
 PAhHdO60wlD2oO6sM/G2DMXs7lBAgFM43qCBeNk+PEfPq6uJpp
 Wp7hmfcXkUHF++G7jQq3PRuJ+l1SqOH/xMZsjXzN5A/sfvc3GT
 7NZZqCVjBgZhm6G+ZUF7j4PiaKFDkDqWshDn06/0zPlvkvS12h
 0Jl0VERuj+jGinY0BaH+KB3RH/mkhAnJCce5Z6U7urpLPFZXw3
 /kYyz1gv7osj1p+SPgYEHlNaJBnnyeGUSJe3dsKGS7wfovLm4a
 ESX33/b79nQKqyNcDzubIxJbthXHVmAuGcL55XhnKAzWhrudrc
 jUQFv1s1yK3yziKmcPsLBnnZS3bdnmhncQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 09:32:15PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-samsung.c |   24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)

Applied, thanks.

Thierry

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8gtSAAoJEN0jrNd/PrOhdyEQAI5ygKUdLXD0I7E96f1+jueE
m434JW2gTWfmyX8DP/CQhr8IyNZuUjOAn4Vj6EQPiuCjuaICE6tQrGaT4ikqFrhv
PHtBgE9gYm42ZMoEqWRqINGtqRK+zD6D13BWG/xHsbIR03lbFkW8HRTnD3VVakEa
YvD92k8TxTqPfz1gtYwe3RArlntWuMjJPFsEmB9rwrP33aVTt30/RC6lG8V5Ijih
gdOdSq4BUp7K5QK7KdrGRr++xFA2Y/5APt1BGYvg5FKTxA/I+pa5om7bmXE5qgtD
ng+8OahIwZfKXmUCAZxlIJImgbF4g/l1ug4BfFEGB/UcLz7ZewVIGu7rWaTFqbex
DsgrhJkQ0BmR2KC0Ygz3xM4XYXhknG8CAW7bLnAoWWeGaWU/MNOnufcqoyqtxevZ
rb9KJuSePk36vt+16wT38+wBPR/ExbPjCjnNnGP9V2gyTnA6q7wv7xMcjM0FZJdw
oH1R6d+BqLGkksLJzl9wIByoWiio8QQMDOQSAl4WiDJvoQEMXq5/xds38zDStChJ
hym0pGIa16ZI3vPe1EJG07v+hAU/XJTuIgTWCa4n+35rF4sDuPCHqlSPHZvGzSoP
PdyyYDpB8u2xAoRNZdn8p0hehhy9NM6e9wT2VkMAhCvQS9Fy/abwsZkPfRdoiYZm
miW6x3CMj//JZ9ZN1JDv
=66u/
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
