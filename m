Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2BQHKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:10:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59663 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814Ab2BQHKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:10:19 -0500
Date: Thu, 16 Feb 2012 23:10:14 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] regulator: fix wrong header name in description
Message-ID: <20120217071013.GB11464@opensource.wolfsonmicro.com>
References: <B567DBAB974C0544994013492B949F8E381301284C@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E381301284C@EXMAIL03.scwf.nsc.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2012 at 10:41:32PM -0800, Kim, Milo wrote:
> The 'mode' is defined in consumer.h.
>=20
> * patch base version : linux-3.2.4

Applied, thanks, but you should only include administrative stuff like
the above after the ---.  You should also always submit patches against
either Linus' tree (for fixes) or -next (for everything else) rather
than an old kernel.

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPf00AAoJEBus8iNuMP3dy6oQAJrumdDmCk4klqAj7e+q59V7
X/B2SRtPSDWbhd5YJr2ZKXHUQrYZssinWPDUJ0M2/750MV+PwAVRdVxLNSkErBAk
nOmOIM6NOUCeMrXHpCUhM/2faapGg4c6SQYX+nh/EeXdshtX5wRDFDkKOxSj1zdx
o/qSBc7knKfpu3OkmBdPhnTClI9U9PNHkts2mvbqNssaHQhJcssjcye/kPmuSOu/
UDfFgAOdJG8d23lGgD7y2k0PDHYwXgeIiNayDxhwqPibgE1yWm08Gwk98G4lT/Qn
ZkJS0RaRcrVIpW6Y7z3l1tHA4Sna7CeJE4eaxNPuRw+umzSjQiUXIY3l/PkyWawh
+94Ds22c6S4lWQ93WlXfMD1sZ06yjSgW3v9TT+SkATZv+dnd9ek5YTpIen1ue2gy
t4cvyOCTt+y7XZsedekhMv+6HSLtXfLUYndLDgW63X/SsFoGqVhXVwjudaMGQx8r
3hMsrCdTzitxkpW/uXltBGLT5iLp7KVD7JGtU5tQkfR34n+OrA6anOPPqnfiVJVK
Um0rxp4IUPUw5TS6beczt4rp3EuancVE/ZDjX+7jz6Pa4PtKO0xegX2Hovy2oB6I
6jsTmW1n6HiY+NA+qq04QmYU+T07dLDC877VLg4BRCrs2KUhSiygkPeJSYbVYExm
i1n49fA3vGh1qw8I5zEr
=VFd4
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
