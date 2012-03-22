Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab2CVUxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:53:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab2CVUxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:53:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] Kbuild: centralize MKIMAGE and cmd_uimage definitions
Date: Thu, 22 Mar 2012 16:53:13 -0400
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
References: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org> <4F6B7226.8000102@wwwdotorg.org>
In-Reply-To: <4F6B7226.8000102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1752955.pLbPd6Gma6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201203221653.19268.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1752955.pLbPd6Gma6
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 22 March 2012 14:40:38 Stephen Warren wrote:
> On 03/16/2012 03:03 PM, Stephen Warren wrote:
> > All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
> > to avoid duplication.
> >=20
> > All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
> > parameterized version in Makefile.lib to avoid duplication.
>=20
> Does this change look reasonable? It has acks from people working on 4
> of the 7 affected architectures; would you prefer acks from all?

isn't that what linux-next is for ? ;)
=2Dmike

--nextPart1752955.pLbPd6Gma6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPa5E/AAoJEEFjO5/oN/WBlkYQAJIXU15l2VlEyOx8RzoCS9jW
Ki02NiRu2kwnisR+QR4/rQqemlL7tRSK5I2FX8CHnaUU7+RVubB72/gfgvZsNATW
46cJA5mjcEzNHQanIkR/qGKYdDUKAlMhWvKojflEGer/ri935vxclxpJsUFPtaup
0qYwdAzZRYiW6+NvZO38H8lUf5yx0hM7dBa6VRSaSxu/dk6B4WQfrvErq1FpYCZL
5zaFNLSz5S6vszYKcIsAUIy6bnwjoCL7uQEoLVd7Y9eU6W+G4RJg1RsURYnX/YYZ
qltVjIXkl+QHWddQZaausgxyZAAZCMvOEZ/stOquNUcp3UpCS2qmkJZXU9+GLjH2
4eyScE6myq/IDGRdz67v9Lmw4iiyVVZF2LFatBs8fdlrS9+hkYBNqdv4tVEUC7gw
SufZJ2nsnR73loViROh2hcvAz56/vRMWt7kASNQ8BM1APyOKpQ98LA6K1liu/MXy
+ZR5+3SV7Rv/nMZ2CbSKslZCPcCDegwPLrKx6KvTG+XMHkh9AGsISnn/Q1vBr0t9
6CXuN7iQBTwaeMXeP+o221fd+qgprWW8TB+cYL9VfT0gON7KowDupJJ3A4VOHH/B
RGnbR+jZPdCn0dSa1qFmY/KgIwc6wnpqjJoQLhGlymJs+850KWWl4Eih+eOBqvOH
RVn2rPjAGCnIKXc0NOe5
=0sml
-----END PGP SIGNATURE-----

--nextPart1752955.pLbPd6Gma6--
