Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1JUWJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 18:09:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1JUWJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 18:09:52 -0400
Date: Sat, 22 Oct 2011 09:09:37 +1100
From: NeilBrown <neilb@suse.de>
To: david@lang.hm
Cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111022090937.7c0d8e8e@notabene.brown>
In-Reply-To: <alpine.DEB.2.02.1110211308130.13493@asgard.lang.hm>
References: <20111020111743.13b40558@notabene.brown>
	<Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org>
	<20111021162340.669742c0@notabene.brown>
	<alpine.DEB.2.02.1110211308130.13493@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2igyGcKq/R1jRx31sZp.xUv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2igyGcKq/R1jRx31sZp.xUv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 13:10:10 -0700 (PDT) david@lang.hm wrote:

> On Fri, 21 Oct 2011, NeilBrown wrote:
>=20
> > Hi,
> >
> > I wasn't going to do this... but then I did.  I think that sometimes co=
ding is
> > a bit like chocolate.
> >
> > At:
> >    git://neil.brown.name/lsusd
> > or
> >    http://neil.brown.name/git/lsusd
> >
> > you can find a bunch of proof-of-concept sample code that implements a
> > "Linux SUSpend Daemon" with client support library and test programs.
> >
> > I haven't actually tested it as root and had it actually suspend and re=
sume
> > and definitely haven't had it even close to a race condition, but the
> > various bits seem to work with each other properly when I run them under
> > strace and watch.
> >
> > It didn't turn out quite the way I imagined, but then cold harsh realit=
y has
> > a way of destroying our dreams, doesn't it :-)
> >
> >
> > Below is the README file.  Comment welcome as always.
> > I'm happy for patches too, but I'm equally happy for someone to re-writ=
e it
> > completely and make something really useful and maintainable.
>=20
> have you put any thought into the idea of extending this slightly to=20
> handle the userspace wakelock interface to potentially allow this to run=
=20
> android userspace on a stock kernel?
>=20
> I realize that there are other things that would be needed as well, but=20
> the wakelock interface is a biggie.
>=20
> David Lang

I have certainly thought of someone else doing it :-)
I only have a high-level understanding of Android interfaces and don't real=
ly
want to go any deeper than that.

Thanks,
NeilBrown

--Sig_/2igyGcKq/R1jRx31sZp.xUv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqHtpznsnt1WYoG5AQJKOw//W8XPrX3iVi/esKv3eSUNqSw/PrK1Q3+Y
WxZUnArLs1cTJwv/FCCC4vep+r4dKj/0ZnyqUhocdwafrPUv7PpmY6RI+Ui/4q9C
6Vs5p0FUghaPGcQocNaxYyD/2ImYRSY4lrK03XwAhYvEQ0+XsoM8WvonTUJVUY8I
txa8Jb0Ximb826pdf4Fom91gsj1Si7L0ALjErQSR3i+suwnaYMSllsEmT4ivaioz
ONIKyHTQG7DzlZKIXPSfVFNIUZC1r173Em/N/QW4hJS8OLhwvcwXbi36CIO57DXB
Z3V7VmIuYw22hIlG+9begh0lin4/4FFA3f4A0hw3Lc6LwcIFR/2hJr7b/hE6ffld
DmyByXYrjxjj5pmcLqK1GowKC0wW/a+Dn94FmoBBu/Z4CnajdljiZX3oyR1dhP0N
BdFXFGJjffLMW/zGHBmsMnKZ2ESoPRWfv7fx1XGePYfL00laParbojkjNiKnyLLv
+0HS8HmbxbOPS0qGgyYCmGi3h64Vnx6GZAP95DwKWH98ZM7jbvnGKkHWr4pioJdT
TAbuKh8p6VEWn3Cz/hCCzcwBkgW8KMegm7/vZZd+C1Eg702z4qmvHme1YDAIGLQg
vPD/bwnysw2rFidKFKc1BaVzEL4RnGVmCnPfOd/noOVtPtLZV8y/lPUbfzutMrfe
pcfStPqiDaY=
=Nx45
-----END PGP SIGNATURE-----

--Sig_/2igyGcKq/R1jRx31sZp.xUv--
