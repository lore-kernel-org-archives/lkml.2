Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2IZB1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:27:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2IZB1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:27:20 -0400
Date: Wed, 26 Sep 2012 11:27:13 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] block: export trace_block_unplug
Message-ID: <20120926112713.226be0ac@notabene.brown>
In-Reply-To: <5061A89A.4050207@kernel.dk>
References: <20120925095755.048903e8@notabene.brown>
	<5061A89A.4050207@kernel.dk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WbBJplYOPn+iaMHNqzMMuHt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WbBJplYOPn+iaMHNqzMMuHt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Sep 2012 14:50:34 +0200 Jens Axboe <axboe@kernel.dk> wrote:

> On 09/25/2012 01:57 AM, NeilBrown wrote:
> >=20
> > Hi Jens,
> >  is there any chance this can be in the next merge window?  I'm
> > adding block tracing to md and found I need another export.
>=20
> No problem, applied.
>=20

Thanks.
NeilBrown

--Sig_/WbBJplYOPn+iaMHNqzMMuHt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJZ8Tnsnt1WYoG5AQILyg//XpHNGDwOZMFdBR7tj9Fu+jUP94O64ADL
ag7LqQ3aCc6Lv8c/V2IfHUO4BbGj5Stuq5ufWlXt5ErYOEsGioGZ+AuDjsH8Iln5
dZQO3wOjuaIPAew3PgG+sVh2Cf6j/mCIdCozVBHlbUHXR5WTzB7ZB91N/XsNMaFc
an7orVVCPjilFw1867sRsp7LTW/rC4b19Ss6nK1/mlOpHGym/liVOVP6Cen7Ri08
mWe/7UUWG/hqV3g0c5eDcLluyq4BVYy9O2hGLcfrpBH/qSl94yn4Dbdpad8KWG9f
3Fhw+atrQRiKhOB2DBMdO7INQNSlGckbqKJJIMgCspSPWSPF4Mp4PInDzNI4arHw
8VxoaGw7fbv0eXQ7pNpjgkPIt2oPcgbqwOB723GV6xNyz0x7HEzzhQ2Z7iZrTnPh
LldePgatrGec+GV5NehS9pqI50sQH6MgFHGN4TSj6chM/oEQ7Xej5UBFB+KX8gti
IzKUrcEwiUkp9fMRHe7CQUCfmOPmY11pqilNDoZs7khqHIVALoF6WG4A3l9FGwAI
B1Pa45deijVvaKf1bV+/0M89a5L1srd8UMvoMKsYqPwQWkEH1Jvb7L0+qlnYtAsI
fHDstkdQwm/nGe8N0YUOdfJCo0jm7iOCxFK41hK/s2qQaoorf9/FDeSaCVuE3/EG
QZpC0sO/fUE=
=UZI/
-----END PGP SIGNATURE-----

--Sig_/WbBJplYOPn+iaMHNqzMMuHt--
