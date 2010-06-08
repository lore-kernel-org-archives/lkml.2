Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0FHCRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:17:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38685 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FHCRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:17:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>, hackbod@android.com
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: Your message of "Tue, 08 Jun 2010 01:17:13 +0200."
             <AANLkTik-0JRJTEbVkr4LUsnELRuqpmGYrRsMxVZDpz8C@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1275834706.7227.545.camel@mulgrave.site> <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain> <1275844114.7227.552.camel@mulgrave.site> <20100606190525.GA20517@infradead.org> <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com> <20100606192405.GA7559@infradead.org> <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com> <1275916830.1645.566.camel@laptop>
            <AANLkTik-0JRJTEbVkr4LUsnELRuqpmGYrRsMxVZDpz8C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275963300_4518P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jun 2010 22:15:00 -0400
Message-ID: <9277.1275963300@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4C0DA7A6.012F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275963300_4518P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 08 Jun 2010 01:17:13 +0200, Linus Walleij said:

> So I would really like to know from the Android people why the
> binder is in the kernel, after all. Could it *theoretically* be in
> userspace, on top of some unix domain sockets, running as a
> real-time scheduled daemon or whatever, still yielding the same
> performance? Or is there some discovered limitation with current
> interfaces, that everybody ought to know?

Not an Android person, but...

How expensive is a userspace->kernel transition on Android-class hardware=
?
There's certainly something to be said for short-circuiting the path
source_process -> kernel -> broker_process -> kernel -> dest_process
down to the shorter source->kernel->dest

--==_Exmh_1275963300_4518P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMDaekcC3lWbTT17ARAt6/AKDbDjjyziWGe4de18hkFdAqzkypvwCghfkj
Ynyp1vcd2/PGbvCNUFucXqo=
=gM5X
-----END PGP SIGNATURE-----

--==_Exmh_1275963300_4518P--

