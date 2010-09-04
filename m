Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0IDUVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 16:21:51 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37943 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0IDUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 16:21:50 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: stable? quality assurance?
Date: Sat, 4 Sep 2010 22:21:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-01231-g11b897c; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de> <201009041839.09261.Martin@lichtvoll.de> <4C829CFF.8080905@s5r6.in-berlin.de> (sfid-20100904_213939_880548_666DFBB9)
In-Reply-To: <4C829CFF.8080905@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1340580.cGEzoFZqgP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009042221.43862.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1340580.cGEzoFZqgP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 04 September 2010 schrieb Stefan Richter:
> Martin Steigerwald wrote:
> > I think main problem is that the current development process does not
> > give time for quality work and bug fixing.
>=20
> This has little to do with process.
>=20
> Put simply, the paid developers work on what they are paid for.  The
> volunteers work on what they are interested in.

And they are paid for features instead of fixing bugs? I doubt enterprise=20
customers have this preference. I admit, they have no reason to pay for=20
fixing my bug, unless they experience it too, however.

> If you feel that too little work is spent on stabilization and bug
> fixing, pay someone or take matters into your own hand.  I.e. report
> bugs and work with the developers to get the bugs fixed.

I do already for the bugs I encountered.

> The current development process OTOH gives plenty of time for quality
> work and bug fixing:
>=20
>   - There are several stages at which new code can be tested:
>     When it lives in subsystem development trees,
>     when it has been pulled into the linux-next tree,
>     when it has been pulled into Linus' tree.
>
>   - Bug fixes are pulled by Linus almost any time whenever they are
> ready. (Of course, since fixes can and do introduce regressions too,
> only critical fixes are accepted in later -rcs.)
>=20
>   - New code submissions are pulled by Linus in a fairly reliable cycle
>     with reasonable frequency (less than three months).  That way,
>     developers know that if their stuff did not quite cut it for
>     mainline merge in month N, they know they can try again in month
>     N+2 or N+3.  They are not left to guess whether their next chance
[...]

I will think a bit more about this. But my first impression is that all of=
=20
these provisions are currently in conflict with time for feature work. If=20
there is no stabilization or sorta of freeze period, the speed won't calm=20
down in order to give stabilizitation a realistic chance.
=20
> > But is that a *given* that no one actually has any influence to? Is
> > collecting changes for next kernel like rain that either pours down
> > or not - usually pours down in this case like in August in Germany
> > ;)? Who feeds Linus with new stuff during the merge window? From
> > what I understand of the Linux development process its mainly the
> > subsystem maintainers and Andrew Morton.
> >=20
> > What if those people stop collecting new stuff for Linus except
> > bugfixes about two or three weeks before the next kernel is relased?
>=20
> Most of the maintainers are responsible enough to put only stuff into
> linux-next which belongs there, i.e. tested, release-ready stuff.=20
> Likewise with submissions to Linus during the merge window.
>=20
> Only some maintainers do in fact try to submit rushed, untested crap.
> Sometimes they get caught red-handed.
>=20
> The release-ready submissions that come via responsible maintainers
> still contain some regressions though.  This is inevitable.  There are
> less regressions if there are more enthusiasts who test development
> trees and linux-next.  There are less regressions in Linus' releases
> if there are more enthusiasts who test -rc kernels.  (And submit good
> bug reports and work with the developers on them.)  And vice versa.
>=20
> Process does not do much to prevent bugs or fix bugs.  People do. :-)

Yes, my suggestion do not guarantee that people do report and fix bugs. But=
=20
it gives more room for doing so, especially regarding fixing the open and=20
known regressions. Again two of those that I mentioned initially have been=
=20
reported by people *during* the rc phase already. Still the stable kernel=20
did not receive the bug fix patch for the nastier one of it in time:=20

That is what I am concerned about. If people do test, do report and=20
someone even does a patch and yet its not in the stable kernel then, what=20
for did they do it?

Okay, it was in 2.6.35.1, but when a major and reported regression is only=
=20
fixed in stable patches I still think that any release without at least two=
=20
or three stable patches should not be called stable at all - its just=20
misleading then. And I think I am perfectly entitled to that oppinion.=20
Anyway I will relabel kernels in my mind and not consider a kernel without=
=20
stable patches stable anymore. I did so theoretically before already but=20
now I experienced it for myself the first time.

> However, you can hardly tell people to implement less features and fix
> more bugs if they don't owe you anything.

Sorry for the demanding tone in my post that initiated the thread, but in=20
the post you are answering too I merely made a suggestion. No one does owe=
=20
me anything and I am aware of that.

But still even when I do not prepend each of my mails with a list of what=20
I have done for the kernel - which is clearly less than what any core=20
kernel developer or even a casual kernel developer did for the kernel  - I=
=20
still can make a valuable suggestion.

That said I compiled a kernel a day or two for some time to help Ingo=20
Molnar with testing an use case for his CFS scheduler. And am I regularily=
=20
testing new TuxOnIce kernels and report back to Nigel how they fare. I=20
report bugs for other open source projects like KDE or Debian as well and=20
contribute a bit here and then, like my first debian package "fio".

And this work mostly has been enjoyable. Neither Ingo, nor Nigel, nor Jens=
=20
Axboe asked me what I did for the kernel prior to working with me. They=20
have just been happy for the feedback I gave.

I admit my initial post did well to provoke the kind of "what did you do?"=
=20
feedback as it actually was demanding. But then I really was frustrated=20
with the kernel and I think sometimes an oppinionated post like my=20
"stable? quality assurance?" can be quite good. If I think a kernel is=20
crap, why should it be prohibited that I tell it to their developers? At=20
least I learned a lot and even started bisecting that bug even though it=20
takes an insane amount of time to do so.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1340580.cGEzoFZqgP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyCqk8ACgkQmRvqrKWZhMfdyQCgneviN9NgliQyQgbBXHZYU2cK
JyYAnj4rVf1nDzrH+qpSWK2gRPkiNGHc
=6OFh
-----END PGP SIGNATURE-----

--nextPart1340580.cGEzoFZqgP--
