Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0K1SIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 13:08:21 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52868 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0K1SIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 13:08:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Damien Wyart <damien.wyart@free.fr>
Cc: Peter Zijlstra <peterz@infradead.org>, tmhikaru@gmail.com,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
In-Reply-To: Your message of "Sun, 28 Nov 2010 12:40:27 +0100."
             <20101128114027.GA2745@brouette>
From: Valdis.Kletnieks@vt.edu
References: <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop> <20101109185516.GQ8332@bombadil.infradead.org> <1289329348.2191.69.camel@laptop> <20101110034507.GV8332@bombadil.infradead.org> <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll> <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop> <1290888920.32004.1.camel@laptop>
            <20101128114027.GA2745@brouette>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290967623_5841P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 28 Nov 2010 13:07:03 -0500
Message-ID: <88912.1290967623@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4CF29A48.0047,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290967623_5841P
Content-Type: text/plain; charset=us-ascii

On Sun, 28 Nov 2010 12:40:27 +0100, Damien Wyart said:
> Hi,
> 
> * Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> > How does this work for you? Its hideous but lets start simple.
> > [...]
> 
> Doesn't give wrong numbers like initial bug and tentative patches, but
> feels a bit too slow when numbers go up and down. Correct values are
> reached when waiting long enough, but it feels slow.

Umm.. maybe the code still averages the 1/5/15 over that many minute's
worth of ticks, which may be longer for a tickless kernel?  

--==_Exmh_1290967623_5841P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8ppHcC3lWbTT17ARAswLAKDxaQF2ERWpxZ8cKrUhLqYZXTHKFACfQhYn
hn4HgdTs5BKjnzDABCAwOcM=
=KFNw
-----END PGP SIGNATURE-----

--==_Exmh_1290967623_5841P--

