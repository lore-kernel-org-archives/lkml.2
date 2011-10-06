Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab1JFRVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:21:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43729 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab1JFRVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:21:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Friesen <chris.friesen@genband.com>, Adrian Bunk <bunk@stusta.de>,
        "Ted Ts'o" <tytso@mit.edu>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Thu, 06 Oct 2011 09:30:47 +0200."
             <alpine.LFD.2.02.1110060913360.18778@ionos>
From: Valdis.Kletnieks@vt.edu
References: <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu> <20111004223932.GA3460@localhost.pp.htv.fi> <20111004231730.GB17089@redhat.com> <20111005075438.GA29441@localhost.pp.htv.fi> <20111005170616.GD4297@thunk.org> <20111005192349.GA14406@localhost.pp.htv.fi> <alpine.LFD.2.02.1110060101130.18778@ionos> <4E8CF3C9.3080908@genband.com>
            <alpine.LFD.2.02.1110060913360.18778@ionos>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317921597_2653P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Oct 2011 13:19:57 -0400
Message-ID: <7726.1317921597@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E8DE340.000D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317921597_2653P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Oct 2011 09:30:47 +0200, Thomas Gleixner said:

> If Linus signs his key, then all it means is that I can be sure to a
> certain degree that the person who is using the key is Adrian. But
> it's neither a free ticket for a k.org account nor does it have any
> other meaning.

Exactly.  It proves it's Adrian. What you *do* with that information is
an entirely different question.

Many people manage to conflate "authentication" and "authorization",
which are two entirely different things in the security world.  My favorite
example demonstrating the difference:

Authentication: "Yes, your driver's license does say you're Jeffrey Dahmer".
Authorization: "Would you like to borrow a steak knife, Jeffrey?"

(For the non-US people - Dahmer was a notorious serial killer and cannibal:
https://secure.wikimedia.org/wikipedia/en/wiki/Jeffrey_Dahmer

--==_Exmh_1317921597_2653P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjeM9cC3lWbTT17ARAtgbAJ9hm+7uQsYxcPBO1l+CRiKTAIbIAgCggRzS
qViZwUvqcBI59By7FMfEagc=
=gpli
-----END PGP SIGNATURE-----

--==_Exmh_1317921597_2653P--

