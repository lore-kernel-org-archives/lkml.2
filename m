Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2DJInu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:43:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48815 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab2DJInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:43:49 -0400
Date: Tue, 10 Apr 2012 09:43:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [linux-next][PATCH] regmap: fix build error if !CONFIG_DEBUG_FS
Message-ID: <20120410084346.GF3149@opensource.wolfsonmicro.com>
References: <1334038367.15859.12.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NQTVMVnDVuULnIzU"
Content-Disposition: inline
In-Reply-To: <1334038367.15859.12.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NQTVMVnDVuULnIzU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 02:12:47PM +0800, Axel Lin wrote:
> Fix build error introduced by commit 9eba4d
> "regmap: fix compilation when !CONFIG_DEBUG_FS".

I've no idea what tree you're testing against but Stephen's fix is
needed for -next.

--NQTVMVnDVuULnIzU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg/KRAAoJEBus8iNuMP3dX48QAJVVtzOoidvGTZUghL75dSTk
Kacg3PNTOgFWHgzGHPkiTaHiG2QmeDIUnqAB7VgPzns6cLANnEkx7Z2jMlthmW3u
xX1WAjnv7v1g+8D2+v6wwcamMQmPamnZepT8FbMqfzKI1fDvFwcHxoPnYWQQAf3a
IzCFygJOkcWukcQyPHPx1UcBaPCH++RqOvqtKzvia/JuiJRyvtphUpDOePiDMJ+Z
eiJGzBRV08aJFJGO2SDIc4D0N2T1DRMTS7DRZQfKn1xO+bPYT0k8ORL/wNztZ7S3
AUOaoJzSd04Ev2ppmHVrxur3m2R8h90wV9Uz3mwyWk0E+uSyp96klL3m4w419p7d
z7UlmV7qnYUOLbBIRxZnJTv3HOjIzjK1CtIt2jqIt8hnJ/MqrfZdC+fuGgJATGc0
gOfg77Bs2gbZJSRkqHqfsJa13eCbmUtPB7/mrATu8eigb/7TwwSG3qOdc16n/CUR
pTj/IfNwmy2BpxKyXxG152qBZrIiuohG6v+L9BievMsb838t+inRyErEHH3yx3m/
zkCHwEvjsMcjW0BfZRLvr1FOgV0Bfd3chHIA0rEGPW6kyh6urFiPgbYzi9VtDC3E
oyRNpmepmMsu1OQtobDhUB5uc28xbIM4C9apQslQbVVAljwwtMzIwFzLjeyZxRXa
Wbuk7Q/tI/mpzmrKSI8y
=l9Vv
-----END PGP SIGNATURE-----

--NQTVMVnDVuULnIzU--
