Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1F2JqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:46:16 -0400
Received: from swan.madduck.net ([80.68.90.58]:45810 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1F2JqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:46:14 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 05:46:14 EDT
Date: Wed, 29 Jun 2011 11:40:18 +0200
From: martin f krafft <madduck@madduck.net>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nested block devices (partitioned RAID with LVM): where Linux
 sucks ;-)
Message-ID: <20110629094017.GA12692@albatross.gern.madduck.net>
Mail-Followup-To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
	linux-kernel@vger.kernel.org
References: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.0.0-rc3-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de> [2011.06.29.09=
14 +0200]:
> 1) The original error message of mdadm about a wrong UUID is
> completely wrong ("device busy" would have been correct)

Correct. It would be nice if you could file a bug about this in your
distro's bug tracker (or Debian's).

> 2) partitions on unassembled raid legs are activated before the
> RAID is assembled, effectively preventing a RAID assembly (I could
> not find out how to fix/prevent this)

I think you will find that LVM snatched the PV before mdadm had
a chance, hence it was busy. This is a common problem with LVM and
RAID1, because LVM (also) scans all devices and because RAID1 is
merely a mirroring setup, LVM can use either of the components just
as well.

The solution? I thought that there was a patch to LVM that prevented
it from using RAID members. But if there isn't, then exclude the
devices from its scan.

=E2=80=A6 and before you claim that Linux sucks, consider how a computer
should do it differently. I think you will find that every
implementation has to make certain hard assumptions (for it lacks
human abstraction and combination abilities), and your current
griefs make you feel like Linux does it worst of all. Rest assured:
it doesn't. It makes assumptions, but you will find that they are
quite sensible.

> I haven't studied the block data structures, but obviously the
> RAID metadata is not at the start of the devices. If they were,
> a partition table would not be found, and the RAID could have been
> assembled without a problem.

You are right, the metadata are not at the start. This is by design.

> I'm sending this message to make developers aware of the problem,

(in which case it might be wise to avoid exclaiming things like
"linux sucks"=E2=80=A6)

> P.S. Novell Support was not able to provide a solution for this problem i=
n time

News at 11=E2=80=A6

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"no, 'eureka' is greek for 'this bath is too hot.'"
                                                            -- dr. who
=20
spamtraps: madduck.bogus@madduck.net

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOCvMBwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xKFN
EACx/O9AKVVDWNQ/2iNBIG3hQWEqiz5aLkuBnQTp74MhkM4vHwkzVFCRb38NOjB6
PewPFqxhUROohGAU+qwPI8BRwbkgzUzknrPrnhVi0yw8NNttWLzf5xvJreetdeKU
uaZ0MTJ2ONHyRKk3rSUo5ot4MpRv5EAca6tEwVBK74Gh+KyT495nRbYTi1IUKQHn
kmT0olgLYnYPdM1MkEpKP/1JQLPqKZMkz9qG2PJK52rG9WOIRE71uYs/Q+4h/XxH
7Xdfz1O5Jz9Rb/8eNy1nDOHg2rFIGkA1qIdHfIb6TeJBcDdq1d2/FFKZrIkJgU5m
9Km/LbpV3VRrQhHTrDr8fZt7WIyAckX8MWf8IOAkt32jzJdWdTuZBJnQH7CG5o77
v3M2JyJQs+wuTfg+vRNIBIkxzBKDrM68b3ysvgfMU73EGbCahXdHMv9OPqklj5mk
2L8G9KSTfoo3aqCb1sqPSszPjtihy68vpiCM+NUUKsDJwXT9pjZ27vS4TvEe9yKL
uDcGoVlXTsepFRL3LmXz6N04l19B4jtP6FTFrV1FqVwQffcvCkKnDDCerXhnWD/2
+uVvX8ZxTS2+McFwSgg/XldJNC10DjKj0pQoBUoRDXvXWjknAFMn/dKxLV/1iJzb
zFhHdFshBdNjwyXEbWB1Igi0in2peNM2IR/Yay2SIX55zg==
=tR+X
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

