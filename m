Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0GLT42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:56:28 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57141 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0GLT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:56:26 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: stable? quality assurance?
Date: Mon, 12 Jul 2010 21:56:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-tp42-toi-3.1-lowmem-free-991-992-04964-gf00c7ec-dirty; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de> <201007121744.05844.Martin@lichtvoll.de> <20100712173625.GE6953@1wt.eu> (sfid-20100712_202952_849487_F77B8D03)
In-Reply-To: <20100712173625.GE6953@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1278968023.N9RSfQIFmO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007122156.21725.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1278968023.N9RSfQIFmO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Montag 12 Juli 2010 schrieb Willy Tarreau:
> Hi Martin,

Hi Willy,

for now I downgraded to 2.6.33.2 and started a compile of 2.6.33.6. I hit=20
yet another bug, but thats a TuxOnIce one (nevertheless reported at=20
bugzilla.kernel.org at #15873). And after booting again after the resume=20
did not work, the machine just locked up again while just playing an avi=20
file from photo sd card - I *think* that dubious freeze bug I mentioned=20
before. Since I am holding a Linux training this week I just decide to=20
downgrade now. Again I didn't try to SSH into the machine, but it was=20
after eight o clock after a long work day, its really hot here and I just=20
couldn't stand doing any collecting information about the bug work that=20
might have easily taken two or more hours. Actually I also do not know=20
what to do with such a random freeze bug? How to best approach it without=20
sinking insane amounts of time into it?

The last freeze bug I had was with my ThinkPad T23 when plugging in and=20
later removing the eSATA PCMCIA card. It worked for quite some kernel=20
versions, but since a certain version it just started to freeze on=20
removal. Upto 2.6.33 where I last tried I think. And there I had at least=20
found on what situation it happens.

What do I do with such bugs? Back then I just decided to not use the eSATA =
=20
PCMCIA card in that ThinkPad T23 again, which isn't that unreasonable I=20
think. I didn't even report, which granted might be the reason that its=20
not yet fixed.

I am willing to do some testing, but I also like to use Linux. And above a=
=20
certain amount its just too much for me. Frankly said for me its all=20
happening too fast. I experienced it with some KDE 4 versions - later ones=
=20
like 4.3 and 4.4! - where I reported so many bug I easily stumpled upon=20
that at some time I just gave up reporting anything. Sure I wanted Radeon=20
DRM KMS. Its great. But I really hope things will be more stable again=20
soon. A new feature is great - when it works. That said, I am not sure=20
whether the recent freeze bug on my ThinkPad T42 is related to Radeon DRM.

I think I wait for 2.6.34.2 or .3 and then try again. If it then happens=20
again, hopefully in a moment where I have nerve to deal with such bugs, I=20
fire up my second notebook and try to SSH into the machine. If that works I=
=20
at least could look into dmesg and X.org logs.

Thats what I meant: For me personally the balance is lost. The kernel does=
=20
not have to be perfect, but I am experiencing just too many issues=20
including quite nasty ones at the moment. 2.6.33.2 with userspace software=
=20
suspend was stable, or 2.6.32 with TuxOnIce. Thus I am trying 2.6.33.6.

> On Mon, Jul 12, 2010 at 05:43:56PM +0200, Martin Steigerwald wrote:
> > > Among the things he explained, I remember that one of primary
> > > concern was the inability to slow down development. I mean, if he
> > > waits 2 more weeks for things to stabilize, then there will be two
> > > more weeks of crap^H^H^H^Hdevelopment merged in next merge window,
> > > so in fact this will just shift dates and not quality.
> >=20
> > Would it make that much of a difference? Linus could still say no to
> > obvious crap, couldn't he?
>=20
> It's not "obvious" crap, it's that the developers will simply have
> advanced two more weeks ahead of their schedule, so their merge will
> be larger as it will contain some parts that ought to be in next
> release should the kernel be release earlier. And it will not be
> possible to delay merging because among them there's always the killer
> feature everybody wants. This is the reason for the strict merge
> window.

Hmmm, it could also be used as two more weeks for testing the new stuff=20
that should go on, but that might just be wishful thinking...

Is the Linux kernel development really in balance with feature work and=20
stabilization work? Currently at least from my personal perception it is=20
not. Development goes that fast - can you all cope with that speed? Maybe=20
its just time to *slow it down* a bit? Does it really scale? I am=20
overwhelmed. Several times I just had enough of it. Others had other=20
experiences. So it might just be me having lots of bad luck. What are=20
experiences of others?

Actually I think a bit more shift to quality work couldn't harm.

> > > There are also some regressions that get merged with every
> > > pre-release. Thus, assuming he would wait for one more pre-release
> > > to merge the fixes you spotted, 2 or 3 more would appear, so
> > > there's a point where it must be decided when to release.
> >=20
> > Some sort of classifying bugs could help here I think. Something that
> > helps Linus to decide whether it is worth to do another release
> > candidate round or not.
>=20
> Maybe sometimes that could indeed help, but that must not be done too
> often, otherwise releases slip and patches get even bigger.
>=20
> (...)
>=20
> > I do
> > think that the Radeon KMS does not work after resume bug (#15969)
> > does qualify since it causes loss of data handled by the current X
> > session(s) - sure I normally save my stuff before hibernating,
> > but... And it actually had a patch that has been tested!
>=20
> Then the problem should be checked on this side : why this patch didn't
> get merged in time ? Maybe the maintainer needed more time to recheck
> it, maybe he was on holiday, maybe he was ill on the wrong day, maybe
> he had already merged tons of fixes and preferred to get this one for
> next time, ... But even if there are fixes pending, this should not be
> a reason to *delay* releases, otherwise we go back to the problem
> above, with also the problem of new regressions reported with tested
> fixes available...
>=20
> (...)

Well it should only be done for major regressions I think. I still think=20
some sorting in the regression list regarding importance and tested patch=20
availability could help. I think that the Radeon DRM fix was quite a low=20
hanging fruit.

> > Maybe an approach would be to dynamically generate the list from all
> > bug reports marked for 2.6.34 versions and have it posted to kernel
> > mailing list after every rc. This way bug #15969 would at least have
> > been in the list of known regressions.
>=20
> In fact, Rafael regularly emits this list, and the respective
> maintainers are informed. That means to me that there's little hope
> that you'll get the maintainers to merge and send a fix they did not
> manage to do. What *could* be improved though would be if Linus
> publically states the deadline for last fixes, as Greg does with the
> stable branch. That can give hopes to some of them to finish a little
> merge work in time instead of considering it's too late.

Hmmm, I did not find any regression list after 2.6.34-rc5 but before 2.6.35=
=20
on kernel mailing list here. And the bug and fix was with rc7. If the list=
=20
would be generated right after every rc? I wouldn't want to demand of=20
anyone to do it that often, but with some automation and a team of people=20
triaging and collecting regressions...

> > Bugzilla severity and priority fields or something similar could be
> > used to set the importance of a bug report and the regression list
> > could be sorted by importance. One important criterion also would be
> > whether someone could confirm it, reproduce it. Even when I reported
> > those desktop freezes, unless someone confirmed them it might just
> > happen for me. Well a "confirm" or vote button might be good, so
> > that the amount of confirmations could be counted.
>=20
> Maybe that could help, but it will not necessarily be the best
> solution. Keep in mind that some issues may be more important but
> still reported only by one user. If one reports FS corruption, you
> certainly don't want to wait for a few other ones to confirm the bug
> for instance. Security issues don't need counting either.

Okay, granted. It would just be a indication.

But a complete or desktop freeze bug could lead to huge data loss, too,=20
depending on when the user saved his data the last time. Thus is it that=20
much more unimportant.

> > > It's not really advisable to call dot-0 releases "unstable" because
> > > it will only result in shifting the adoption point between the user
> > > classes above. We need to have enthousiasts who proudly say "hey
> > > look, dot-0 and it's already rock solid". We've all seen some of
> > > them and they're the ones who help reporting issues that get fixed
> > > in the next stable release.
> >=20
> > I do think the claim should be honest. "stable" IMHO is not, at least
> > from a user's point of view. "unstable" isn't either, cause a dot-0
> > kernel is not guarenteed to be unstable ;). So I agree with the
> > major release kernel approach from Rafael.
>=20
> But it's also the starting point of the stable branch. And what about
> the -stable branch itself. Sometimes an awful bug will prevent the
> kernel from even booting for most users, and a single patch will be
> present in the stable branch to fix this early. Same if a major
> security issue gets discovered at the time of release, it's possible
> that the stable branch only contains one patch. That does not qualify
> it for more stable than the main branch either, eventhough it's called
> "stable". Maybe we should indicate on www.kernel.org that a new
> release has generally received little testing but should be good
> enough for experienced users to test it, and that stable releases
> before .3-.4 are not recommended for general use.

I thought about calling it a "major kernel release" or something like that=
=20
from dot-0 and then after stable patches settle - but on what criterion to=
=20
decide that? - "stable". Just .3 or .4? Or when there have been some dot=20
releases with few patches? But then what if Greg just takes a bit longer=20
to make the next one and it just contains more patches due to that reason?

> > But beyond that, I do think its worth thinking about ways to improve
> > the process of ensuring as much stability as sensibly possible. A
> > dot-0 kernel won't be error-free - but I find just claiming the
> > current process as "the best we can have" not actually satisfying.
> > And I do think it can be improved upon. I do not do kernel
> > development, but I am willing to help with collecting information
> > about the current state of the kernel, help with bug triaging as
> > good as I can and manage to take time. I do have some experience
> > with quality management as I coordinated the betatest of some
> > AmigaOS versions,  but then this has been in a closed group. Here
> > its a different scale and I believe it needs somewhat different
> > approaches.
>=20
> In fact, I think we're at a point where the development process scales
> linearly with every brain and every pair of eyeballs. There are two
> orthogonal axes to scale, one on the quality and one on the quantity.
> Both are required, but the time spent on one is not spent on the other
> one. Customers want quantity (features) and expect implicit quality.

Don't customers also want stability? I certainly want it. And many people=20
running servers too in my experience.

> It is possible for some people to bring a lot of added value, a lot
> more than they would through their share of brain time on code. This is
> the case for Rafael and Greg who noticeably enhance quality, but it's
> not limited to them too. Code reviews, bug reviews, -next branch,
> etc... are all geared towards quality. But one thing is sure, there
> are far less people working on quality than there are working on
> features, so I think that if you want to help, there is possibly a way
> to noticeably improve quality with one more guy there, though you have
> to find how to efficiently spend that time !

Yes, and I didn't find that yet. I am not in a state where I can just read=
=20
kernel code and actually understand what it does. Where I might be able to=
=20
start helping with his collecting and categorizing bug and regression=20
information, bug triaging and stuff. For some bugs at least. I think there=
=20
are bugs where I just do not understand enough to do anything helpful.

Last post for today. Enough of computing.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1278968023.N9RSfQIFmO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw7c14ACgkQmRvqrKWZhMevKQCeP5RCV0Hj6g3BxOfPkCazQPvo
NQ8AoJLlJRl3233QPq02AK8MnpqYpuF1
=pkb9
-----END PGP SIGNATURE-----

--nextPart1278968023.N9RSfQIFmO--
