Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2A2VmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:42:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57219 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab2A2VmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:42:07 -0500
Date: Sun, 29 Jan 2012 21:42:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Sound, SoC, WM9090: Remove unused variable 'wm9090' from
 wm9090_i2c_remove()
Message-ID: <20120129214205.GD2994@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1201280055410.13952@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201280055410.13952@swampdragon.chaosbits.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2012 at 12:57:42AM +0100, Jesper Juhl wrote:
> The variable 'wm9090' is assigned to but never used, so let's just
> remove it.

There's already a fix in for this (adding use back).

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJb0kAAoJEBus8iNuMP3d1ikP/RZFTU8ntAyoDce0lTOSPcj8
+vpgsyC6rGxPpFdzHaeNtLaYMOhI+N9BGA3cmUHhwUFVDNalU4AwOaLsKywYJRfW
R2g9uZqOLa1GLQDRVCU+BnSZ8UAc3k+cgbYoJzbTzBkgwApjPt/DObQUqeLGYTbh
ps04fpGl9tper3nnTe/Ke3HcmEwHKgnP3bYX721GGk3D90KUthBoMeePFCRkftgJ
wNgN2Ppb29CnI7sTfdFkLql3WL1kB0GdQO+5fp4Qq3pausUdBDdZHFfK8tGPmtos
lG7qkpnz3Ecx5NqNhrajk1fLqIibi8sRCIDEuitrpFPJi7hyP+gSAcEDMJ3XF0cV
88gCDzmxco6g5vOigZvSyaV/wfZPUK4/W8uzbgdgHjl3rm77aWxgfE/DwfJg8OdR
yFGsyEvRDPFV+fi6Kkgr1gZEIdYbozDxTcBKCVdeLaMrHV/7OUWUl6VN4IkCsfGw
2MMZf120v4ZsCBAB7q2cxy5Oz3ztQW4NzJGmg40a6WhTDsxvY7LB1POh4BNyOVai
G6vkkkyZ4YSIkssAJKHjCALzBm/qssmsrkSk4Q0AjUOnpAwiPEVIuiJ40kCC/2QL
0hlu8tluaOi/3gPxJL3/kzU7ucmoaCMXi0TbE0pNYGK763NHKnjnD7Go54Kafoim
Clvtrq6lcGRmQuXxaKWs
=jFN1
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
