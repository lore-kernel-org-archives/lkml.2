Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2ATEPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 23:15:04 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51534 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2ATEPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 23:15:01 -0500
Date: Fri, 20 Jan 2012 15:14:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: Linux 3.3-1 out - merge window closed
Message-Id: <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
In-Reply-To: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jan_2012_15_14_52_+1100_db_VWmM868UjUfQx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jan_2012_15_14_52_+1100_db_VWmM868UjUfQx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 19 Jan 2012 15:58:28 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> (Stats for those that like them: 20% arch updates (arm, power, mips,
> x86), 60% drivers (networking - wireless in particular, staging,
> media, dri, sound, misc - including getting rid of 'struct sysdev'),
> and 20% random stuff: filesystems, networking, perf etc)

More stats for the bored:

(I don't count merge commits below and everything is relative to v3.2)

Of the 8899 commits in v3.3-rc1, 6918 were in next-20120106 (the first
-next based on v3.2).  A further 792 commits have the same subject line as
commits in next-20120116 and a further 16 have the same patch-id.

This leaves 1174 commits (13%) in v3.3-rc1 that were not in next-20120106
for some reason (not too bad really, I guess).  Some will clearly be bug
fixes, of course.  Some will be quilt trees (probably rebased before
being sent to Linus).  Some will be patches that depend on work by others.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jan_2012_15_14_52_+1100_db_VWmM868UjUfQx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPGOo8AAoJEECxmPOUX5FERT8P/1LPL4Qmwyh/Wf4R5waC8nSb
VwylQInwwq1vchQsNQDDE5XKPnDudOUAXuu8VpkQcH+BfopY25IdDX958cG5lgGs
6ArjrnQiLiVmBPWI3iX+8LtV+Kt8jscszTwUZ2VhWtg+2zCJt1/ytMCAJVVufa23
OXMFIYjTiDZw234yYtaQwrG+ZaAhrlPUq3b0zVx0drxKYXdPeB/xfQjRc3+7+lIz
g8LHWkCmWeN1LnArAFDfgVDiGzLr+eN2xaRxnxAeO7t1rwLecSONtc7dP5RMD/6m
vtiR+qbNPIRUb4dFkfDxS88h9QciT2p88qAjTy7J0zxLGRswndjvJG6GLCklGsVW
rFiZo/AcU1oiFpFYG5bZlRQBLadnlXhI133E+budzl6yREMy5FzwRADqoqLZm5uJ
tTI78B8OnXNoYs/yyu7uW6Efbjz6jKpx0ZarYl5SVY8fmmIwCyM2bscUpZjXTet2
DpYrbgGcv996q/8RdyJ4k/qLLQa8f91JyHtRu2Mc6KS2pp9mElEWvLCpMPtk+OAY
sup7d8KFDs6WQDvGaX0wNGHL8MDMe+zaaeahPOvuT5ZCqRr2Fu4YxQ+kBsrg7Fke
DZREhQHcsoDP+hDTZKMQQH3vXGjF6R97W68TsdsV0ChIJIoxqG6xW/m2Q50mhfD3
oRCuUVazyHWGlMboDq3l
=CXam
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jan_2012_15_14_52_+1100_db_VWmM868UjUfQx--
