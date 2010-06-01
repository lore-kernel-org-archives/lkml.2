Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0FASbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:31:04 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55488 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0FASbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:31:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What computer do Linus and other prominent kernel developers have?
In-Reply-To: Your message of "Tue, 01 Jun 2010 19:28:01 +0200."
             <AANLkTinUwSwiMKsP6ocBJpHMX83YLZaADylHasdyqJEu@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTinUwSwiMKsP6ocBJpHMX83YLZaADylHasdyqJEu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275417053_7824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Jun 2010 14:30:53 -0400
Message-ID: <24873.1275417053@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C0551DD.018A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275417053_7824P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Jun 2010 19:28:01 +0200, "Fred ." said:
> What exact computer hardware components do Linus Torvalds have in his
> computer system?
> Also other prominent kernel developers like Alan Cox, etc.
> 
> If want to buy same motherboard, CPU, GPU, HDD, etc.
> 
> That way, I know there wont be any problems running Linux, because if
> I have that problem,
> then he will also have that problem.
> If he have that problem, he will surely fix it.

I'm not a prominent developer, I'm just a semi-famous crash test dummy, but.. ;)

"Hey, we just found something which doesn't crash my Vaio!" -- Andrew Morton

Note carefully the following problems with your plan:

1) People like Linus, Alan, and Andrew are all perfectly capable of running
a kernel that has a cherry-picked fix or two on it.  So it's quite possible
they have a system that 2.6.34 doesn't run on, but 2.6.34 plus 3 fixes does.
This can add substantially to your support costs.

2) It may not even be possible to *get* the exact same configuration anymore,
because the vendor has changed things around.  I have a Dell Latitude E6500
laptop. It has a " MATSHITA DVD+/-RW UJ892" in it.  If you buy an E6500, there
is a good chance it will come with some *other* DVD  burner (one of my
co-workers kept count, and was up to over a dozen different CD drives/models
that Dell shipped during the long production run of one of their Optiplex
models).

3) If they have some odd hardware config, and you have troubles installing/
maintaining it on that odd config, you're unlikely to be able to get personal
support from them.  However, if you get the same config as 3 zillion Linux
fanboys, any one of them will be able to bail you out. (I tell newcomers to
Linux not to install the distro that's "cool" - install the distro you can get
tech support by buying a pizza for the teenager next door. ;)

4) It's quite possible they have hardware that has known issues that don't
bother them in their daily usage, but render it useless for your usage. (For
instance, I have *no idea* if suspend works on this E6500, because I never
use suspend - it's not even built into my kernel.  If it's broken on this
model and you *need* suspend support, you'll be a very unhappy camper.

4a) A related issue - not only do you need the same hardware, but also the
same .config and distro, in case there's mis-match out there.  And some
developers do odd things either because they just haven't bothered upgrading
their userspace, or they intentionally want to test kernels for backward
compatibility.  I think Andrew still has a Fedora 7 or 8 out there.  Will
suck if you get that same hardware and discover you need Fedora 13 to support
some software you need and Andrew doesn't use...

--==_Exmh_1275417053_7824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBVHdcC3lWbTT17ARApfqAJ4+6708keYPibUQiI6rQI/i3od9AACg/KNC
KIrgG6i8AymOZIYAzsI7OoQ=
=eQoB
-----END PGP SIGNATURE-----

--==_Exmh_1275417053_7824P--

