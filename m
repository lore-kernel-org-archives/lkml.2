Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0GLVkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:40:13 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53723 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0GLVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:40:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Date: Mon, 12 Jul 2010 23:39:58 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.6-tp42-toi-3.1.1.1-04982-g768d8a0; KDE/4.4.4; i686; ; )
References: <201007110918.42120.Martin@lichtvoll.de> <4C3B585A.6090106@s5r6.in-berlin.de> <4C3B73D7.8050802@davidnewall.com> (sfid-20100712_220118_147710_090EA85C)
In-Reply-To: <4C3B73D7.8050802@davidnewall.com>
Cc: David Newall <davidn@davidnewall.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Marcin Letyns <mletyns@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1886727.sGzWQhEPf9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007122340.06951.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1886727.sGzWQhEPf9
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Montag 12 Juli 2010 schrieb David Newall:
> Stefan Richter wrote:
> > David Newall wrote:
> >> Thus 2.6.34 is the latest gamma-test kernel.  It's not stable and I
> >> doubt anybody honestly thinks otherwise.
> >=20
> > It works stable for what I use it for.
>=20
> Mea culpa.  I didn't mean that 2.6.34 is unstable, but that the term
> "stable" is not appropriate for a newly released kernel; "gamma" should
> be used instead.

I indeed think stable should mean "stable for the majority of users". Its=20
difficult to estimate. But I doubt that every dot-0 release qualified for=20
that.

> Merely six months ago 2.6.32 was released; today we're preparing for
> 2.6.35; a new kernel every two months!  Perhaps 2.6.31 is truly the
> latest stable kernel; or else 2.6.27 does, which is the other 2.6 on
> the front page of kernel.org.  I'm pretty sure 2.4 is stable (which
> might explain why I see it embedded *much* more frequently than 2.6.)

I have these metrics:

martin@shambhala:~> uprecords -m 20 | cut -c1-70
     #               Uptime | System                                 =20
=2D---------------------------+-----------------------------------------
     1    36 days, 09:57:31 | Linux 2.6.32.3-tp42-toi-  Tue Jan 12 09:
     2    31 days, 01:07:24 | Linux 2.6.26.5-tp42-toi-  Tue Sep 30 13:
     3    24 days, 13:29:07 | Linux 2.6.33.2-tp42-toi-  Mon May 31 22:
     4    21 days, 15:08:21 | Linux 2.6.29.2-tp42-toi-  Tue Apr 28 22:
     5    19 days, 21:22:14 | Linux 2.6.33.2-tp42-toi-  Tue May 11 17:
     6    19 days, 09:49:05 | Linux 2.6.32.8-tp42-toi-  Fri Mar  5 11:
     7    18 days, 02:31:41 | Linux 2.6.29.6-tp42-toi-  Thu Jul  9 09:
     8    17 days, 12:38:36 | Linux 2.6.28.8-tp42-toi-  Wed Mar 18 10:
     9    16 days, 16:10:28 | Linux 2.6.31-tp42-toi-3.  Tue Sep 22 21:
    10    15 days, 14:39:26 | Linux 2.6.28.4-tp42-toi-  Mon Feb  9 22:
    11    15 days, 13:58:12 | Linux 2.6.27.7-tp42-toi-  Tue Dec  9 22:
    12    13 days, 21:11:06 | Linux 2.6.31-rc7-tp42-to  Mon Aug 31 21:
    13    13 days, 18:34:00 | Linux 2.6.29.2-tp42-toi-  Wed May 27 19:
    14    12 days, 21:54:18 | Linux 2.6.26.5-tp42-toi-  Fri Oct 31 13:
    15    10 days, 22:02:14 | Linux 2.6.28.7-tp42-toi-  Thu Feb 26 16:
    16    10 days, 16:29:02 | Linux 2.6.33.2-tp42-toi-  Fri Jun 25 19:
    17    10 days, 08:04:52 | Linux 2.6.26.2-tp42-toi-  Thu Sep 18 14:
    18    10 days, 03:52:30 | Linux 2.6.31.3-tp42-toi-  Thu Oct 15 09:
    19     9 days, 22:03:29 | Linux 2.6.31.5-tp42-toi-  Tue Nov  3 11:
    20     9 days, 00:24:22 | Linux 2.6.29.2-tp42-toi-  Thu Jun 25 14:
=2D---------------------------+-----------------------------------------
=2D> 116     0 days, 00:52:03 | Linux 2.6.33.6-tp42-toi-  Mo
=2D---------------------------+-----------------------------------------
1up in     0 days, 00:31:56 | at                        Mon Jul 12 23:
t10 in    15 days, 13:47:24 | at                        Wed Jul 28 12:
no1 in    36 days, 09:05:29 | at                        Wed Aug 18 08:
    up   608 days, 02:40:08 | since                     Thu Sep 18 14:
  down    54 days, 06:12:57 | since                     Thu Sep 18 14:
   %up               91.808 | since                     Thu Sep 18 14:

And 228 entries in there in total since 2.6.26, with=20

martin@shambhala:~> uprecords -m 300 | cut -c1-70 | grep "0 days" | wc -l
148

entries for shorter than one day.

Sure these are not to be read without the experiences I made and the=20
reasons for rebooting, since sometimes just I messed up with some kernel=20
option and compiled another one.

AFAIR 2.6.26 upto 2.6.32 has been fine, except 2.6.30 where TuxOnIce just=20
didn't work, but I am not yet sure whether this was caused by TuxOnIce or=20
by some problem with general hibernation infrastructure. I then just=20
omitted 2.6.30. Since I only tried 2.6.31 with my T42 I got an whooping=20
uptime of over 100 days for 2.6.29 on my T23! Thats stable. Well any=20
kernels that reproducably reach more than 15 or 30 days are quite stable=20
in my own subjective consideration. Most kernels that got that far would=20
likely have lastest much longer if I didn't just compile the next one, be=20
it a dot release or a major release.

This all without Radeon KMS!

2.6.33.2 was only stable when I used Radeon KMS without TuxOnIce. Ok, so=20
might be a TuxOnIce problem, but then at least those quite frequent hangs=20
on hibernation at the place where the screen goes black for a few seconds=20
and comes back then which I had with 2.6.33.2 where gone for 2.6.34. Maybe=
=20
they are gone with 2.6.33.6 since it carries some more radeon drm fixes.

2.6.34 did not reach an uptime of more than 2 or 3 days yet.

Well maybe Nix is right and its just that Radeon KMS has not been=20
stabilized enough and rest of kernel is quite stable.

And when the combination of 2.6.33 now .6 and userspace software suspend=20
works for me - for the first time, often it was TuxOnIce that worked, but=20
not any in kernel method I tried from time to time - so be it for the time=
=20
being, even if userspace software suspend is way slower and doesn't=20
satisfy the disk on writing the image.

> > If it doesn't for you, then I hope you are already in contact with
> > the respective subsystem developers to get the regressions that you
> > experience fixed.
>=20
> (Segue to a problem which follows from calling bleeding-edge kernels
> "stable".)
>=20
> When reporting bugs, the first response is often, "we're not interested
> in such an old kernel; try it with the latest."  That's not hugely
> useful when the latest kernels are not suitable for production use.  If
> kernels weren't marked stable until they had earned the moniker, for
> example 2.6.27, then the expectation of developers and of users would
> be consistent: developers could expect users to try it again with
> latest stable kernel, and users could reasonably expect that trying it
> wouldn't break their system.

I think thats really a question on how to attract more widespread testing.=
=20
=46or wider spread testing it needs to be stable enough to have enough user=
s=20
deal with it. But without wider spread testing it might not get there.

I just dropped 2.6.34 for now and I will wait for more dot releases. Maybe=
=20
I am really the only one for whom 2.6.34 doesn't work, maybe just other=20
people did so to frustrated without telling here or in bugzilla.=20

Maybe providing better ways to report bugs and gather information even on=20
freeze bugs without setting up too much manually could help. I certainly=20
think that the enhanced DrKonqi crash reported from KDE 4.3 and up helped=20
users to provide *good bug reports*. Maybe there could be something like=20
that for the kernel and an easy option to have the kernel store even=20
backtraces for hard crashes. Unfortunately there is no reset button on=20
notebooks, so memory might be the wrong place. Well one could dedicate a=20
ring buffer space on the swap partition for that or something like that -=20
that area should be writable even when no filesystem is not working=20
anymore. On next reboot the bug report application recovers the crash data=
=20
from there. Would impose a risk that on severe memory corruption the=20
kernels write crash data elsewhere, where it shouldn't save it. An USB=20
stick comes to mind, but what when the USB stack doesn't work anymore?

Well not every bug is a freeze bug and maybe something could be done for=20
non freeze bugs. Like an application which records selected data while the=
=20
user reproduces the bug. Just like enhanced DrKonqi collects crash data=20
and even helps the user to install necessary debug packages.

But I think when a kernel behaves to unstable for lots of users they just=20
drop it. Some bugs are okay, but especially freeze bugs and even more so=20
fs corruptions bugs scare non die-hard kernel debuggers who bisect a=20
kernel a day away.

Maybe I just had lots of bad luck, so I would love to hear other=20
experiences, some already said 2.6.34 works pretty stable for them.

I will leave 2.6.34.1 on my T23 which has a Savage which maybe will never=20
get KMS, who knows, and on the workstation at work, which doesn't use=20
Radeon KMS due to rock solid stable Debian Lenny userspace. Maybe this at=20
least sheds a light, whether most of my issues have likely been Radeon KMS=
=20
related.

As a side note: Ext4 is absolutely rock stable for me! As is XFS on my T23=
=20
and even BTRFS for the T23 /home and some work directory on the=20
workstation (not yet on my production T42).

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1886727.sGzWQhEPf9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw7i68ACgkQmRvqrKWZhMefcACgiiK1I9cirYfdXt/sEfKAlbxe
xRUAn3faVNnmY/5qbdjSiy25bnJ/yIOh
=VS0K
-----END PGP SIGNATURE-----

--nextPart1886727.sGzWQhEPf9--
