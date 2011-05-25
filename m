Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab1EYBOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 21:14:04 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35589 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1EYBOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 21:14:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm <linux-mm"@kvack.medozas.de
Subject: Re: (Short?) merge window reminder
In-Reply-To: Your message of "Tue, 24 May 2011 14:30:59 +0200."
             <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com> <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com> <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
            <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306285994_4707P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 21:13:14 -0400
Message-ID: <6043.1306285994@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DDC57AF.0120,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306285994_4707P
Content-Type: text/plain; charset=us-ascii

On Tue, 24 May 2011 14:30:59 +0200, Jacek Luczak said:
> 2011/5/24 Jan Engelhardt <jengelh@medozas.de>:
> > On Tuesday 2011-05-24 01:33, Linus Torvalds wrote:
> >
> >>Another advantage of switching numbering models (ie 3.0 instead of
> >>2.8.x) would be that it would also make the "odd numbers are also
> >>numbers" transition much more natural.
> >>
> >>Because of our historical even/odd model, I wouldn't do a 2.7.x -
> >>there's just too much history of 2.1, 2.3, 2.5 being development
> >>trees.
> >
> > .oO(Though once 2.{7 or more, odd} trickle into the distros, it would
> > become pretty much apparent that they are not devel.)
> >
> >>And then in another few years (probably before getting close to 3.40,
> >>so I'm not going to make a big deal of 3 = "third decade"), I'd just
> >>do 4.0 etc.
> >
> > While 2.6 has certainly worn out, already thinking of a 4.0 is highly
> > reminiscient of the version number arms race Firefox and ChromeBrowser
> > are doing currently.
> >
> >>Because all our releases are supposed to be stable releases these
> >>days, and if we get rid of one level of numbering, I feel perfectly
> >>fine with getting rid of the even/odd history too.
> >
> > If I remember past-time discussions right, ELF was the contributing
> > factor to bump the major number to 2.0 back then; ever since 2.0, no
> > similarly breakthrough-ing event has occurred.
> 
> What then about BKL removal? Nice place to celebrate with version jump
> and heaving some beers.

Well, if we're looking at ELF-sized ABI changes, how about 3.0 be the
release where we re-sync the syscall numbers on all the archs? ;)

--==_Exmh_1306285994_4707P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3FeqcC3lWbTT17ARAv04AJkBCqmgJQk5Su57aDSar4uSGf4s4wCg4k/H
+Qm5XV5rza4hbeoNy0XS7gk=
=UhnL
-----END PGP SIGNATURE-----

--==_Exmh_1306285994_4707P--

