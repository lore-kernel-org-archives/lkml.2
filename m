Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab1EZSpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:45:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40047 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab1EZSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:45:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
In-Reply-To: Your message of "Thu, 26 May 2011 20:36:35 +0200."
             <20110526183635.GA2490@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu> <4DDE31D6.4070209@redhat.com> <20110526113842.GA27618@elte.hu> <4DDE96B7.8030006@redhat.com> <20110526181554.GB3572@elte.hu> <4DDE99F6.4030804@redhat.com>
            <20110526183635.GA2490@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306435422_8338P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 14:43:42 -0400
Message-ID: <20614.1306435422@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DDE9F60.0091,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306435422_8338P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 May 2011 20:36:35 +0200, Ingo Molnar said:

> I suspect we are really offtopic here, but an initial rsync, then 
> stopping the guest, final rsync + restart the guest at the target 
> would work with minimal interruption.

Actually, after you kick off the migrate, you really want to be tracking in
real time what pages get dirtied while you're doing the initial copy, so that
the second rsync doesn't have to walk through the file finding the differences.
 But that requires some extra instrumentation.


--==_Exmh_1306435422_8338P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3p9ecC3lWbTT17ARAqEVAJwNve8j+tXaEfXOEy2EP+RCByBU6QCg+L9y
tS46V2pR0cEoJpGc8PVoH3g=
=fwI1
-----END PGP SIGNATURE-----

--==_Exmh_1306435422_8338P--

