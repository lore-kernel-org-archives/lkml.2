Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0IDRMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:12:34 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42215 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0IDRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:12:33 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Date: Sat, 4 Sep 2010 19:12:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-rc4-tp42-00127-g3a86e18; KDE/4.4.5; i686; ; )
Cc: "Ted Ts'o" <tytso@mit.edu>
References: <201007110918.42120.Martin@lichtvoll.de> <20100711131640.GA3503@thunk.org> (sfid-20100711_203645_052189_5A0C8550)
In-Reply-To: <20100711131640.GA3503@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2707226.GQ0gmjx32X";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009041912.28770.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2707226.GQ0gmjx32X
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi Ted,

I wanted to answer this for a long time...

Am Sonntag 11 Juli 2010 schrieb Ted Ts'o:
> On Sun, Jul 11, 2010 at 09:18:41AM +0200, Martin Steigerwald wrote:
> > I still actually *use* my machines for something else than hunting
> > patches for kernel bugs and on kernel.org it is written "Latest
> > *Stable* Kernel" (accentuation from me). I know of the argument that
> > one should use a distro kernel for machines that are for production
> > use. But frankly, does that justify to deliver in advance known crap
> > to the distributors? What impact do partly grave bugs reported on
> > bugzilla have on the release decision?
>=20
> So I tend to use -rc3, -rc4, and -rc5 kernels on my laptops, and when
> I find bugs, I report them and I help fix them.  If more people did
> that, then the 2.6.X.0 releases would be more stable.  But kernel
> development is a volunteer effort, so it's up to the volunteers to
> test and fix bugs during the rc4, -rc5 and -rc6 time frame.  But if
> the work tails off, because the developers are busily working on new
> features for the new release, then past a certain point, delaying the
> release reaches a point of diminishing returns.  This is why we do
> time-based releases.

It sure helps quality of the kernel if people test rc candidates of them=20
and report bugs, but I think at least partly you missed my point. I wrote=20
in my initial mail:

> 2.6.34 was a desaster for me: bug #15969 - patch was availble before=20
> 2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as=20
> well as most important two complete lockups - well maybe just

So two out of three bugs I experienced - the third one being [Bug 16376]=20
random - possibly Radeon DRM KMS freezed I am currently bisecting -=20
actually have been from testers that actually tested rc kernels. One even=20
had a patch prior to releasing 2.6.34.

So for these two bugs testing rc kernels clearly has not helped raising=20
the *release* kernel quality.

I now understand that deferring a stable kernel release can cause a lot of=
=20
pain. But still I have the question why at least the patch from the bug=20
15969 has not been taken prior to release? Not to find some guilt, but to=20
possibly find ways to improve the process. I can't check bugzilla right now=
=20
due to too many MySQL connections on the server - already reported, but=20
supposedly already known to the admins anyway - but AFAIR the patch has=20
been available and AFAIR also tested way before the release.

So my question still stands whether anything can be improved with at least=
=20
getting as much bugfix patches from Bugzilla into stable kernel. At least=20
for critical bugs like does not boot or only garbage on screen after=20
booting.

I can accept that bug 15788 would have been missed by that, but this bug=20
was not that important - it was just the tip on the iceberg.

> It is possible to do other types of release strategies, but look at
> Debian Obsolete^H^H^H^H^H^H^H^H Stable if you want to see what happens
> if you insist on waiting until all release blockers are fixed (and
> even with Debian, past a certain point the release engineer will still
> just reclassify bugs as no longer being release blockers --- after the
> stable release has slipped for months or years past the original
> projected release date.)

I made a suggestion on how to improve the development process while still=20
holding to time-based releases in my other mail to this thread today.

> So if you and others like you are willing to help, then the quality of
> the Linux kernels can continue to improve.  But simply complaining
> about it is not likely to solve things, since threating to not be
> willing to upgrade kernels is generally not going to motivate many, if
> not most, of the volunteers who work on stablizing the kernel.

I do, but I need to balance this. I already spend quite some hours on=20
bisecting that freeze bug mentioned above and it might take some more=20
weeks to nail it down.

And it was not a threat at all. I just have to balance how much=20
instability I can take on systems that I use for my daily stuff.

> > I am willing to risk some testing and do bug reports, but these are
> > still production machines, I do not have any spare test machines, and
> > there needs to be some balance, i.e. the kernels should basically
> > work.
>=20
> So you want the latest and greatest new features in a brand-new kernel
> release, but you're not willing to pay for test machines, and you're
> not willing to pay for a distribution support...  The fact that you
> are willing to do some testing is appreciated, but remember, there's
> no such thing as a free lunch.  Linux may be a very good bargain (look
> at how much Oracle has increased its support contracts for Solaris!),
> but it's still not a free lunch.  At the end of the day, you get what
> you put into it.

Ted, I think there is no need to attack me like that. Actually all of the=20
bugs have been on my laptop that I use for work *and* private work. Most=20
of the time I spent on these bugs have been during my spare volunteer time=
=20
as well. And we are yet a small company.

When I apply what you wrote above, the only sane thing would be to use a=20
distro kernel and be done with it - which means less testing of recent=20
kernels. Still even then that likely radeon kms related freeze could have=20
slipped even into Debian stable kernel, considering that no one posted to=20
the bug report that he was able to reproduce the bug.

Then I'd just accept the slower turn-around cycles with in kernel or=20
userspace software suspend and be done with compiling TuxOnIce kernels.=20

But I am not there yet. Cause compiling TuxOnIce kernels worked pretty=20
well prior from 2.6.11 to 2.6.33. And I want to help as good as I can.=20
Hopefully after bisecting the radeon kms relate freeze bug thinks are=20
calmer again - although there is another wierd, possibly difficult to track=
=20
bug left. Maybe I just had lots of bad luck with 2.6.34, and after=20
tracking those two bugs things are calmer again. The Radeon KMS stuff has=20
been a big change as well.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2707226.GQ0gmjx32X
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyCffYACgkQmRvqrKWZhMegrwCfWbYxKMgiGCZecthLsQHxQ6SG
HTQAoIsWvY6+3ftBaneksoQO+5Gekl3H
=k2ip
-----END PGP SIGNATURE-----

--nextPart2707226.GQ0gmjx32X--
