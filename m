Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1ITWey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:34:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38089 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1ITWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:34:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Christoph Lameter <cl@gentwo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for this_cpu_read/write()
In-Reply-To: Your message of "Tue, 20 Sep 2011 11:08:56 CDT."
             <alpine.DEB.2.00.1109201108080.8056@router.home>
From: Valdis.Kletnieks@vt.edu
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home> <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu> <alpine.DEB.2.00.1109200955190.8056@router.home> <1316531987.29966.65.camel@gandalf.stny.rr.com>
            <alpine.DEB.2.00.1109201108080.8056@router.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316557979_2679P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Sep 2011 18:32:59 -0400
Message-ID: <26045.1316557979@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E79149C.00F5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316557979_2679P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Sep 2011 11:08:56 CDT, Christoph Lameter said:

> That is obviously a use case in which this_cpu_xx ops could not be used
> since we must stay on the same cpu.

Wow.  I don't think I've ever seen a single sentence scream quite so much
"totally broken API" in as few words.


--==_Exmh_1316557979_2679P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOeRSbcC3lWbTT17ARAisdAKDIeKiSGpHSxpQkhprNUk4B3JDIewCcDLU+
O8CFsmIqBEhZSOP4V9Tr9fo=
=ZWTI
-----END PGP SIGNATURE-----

--==_Exmh_1316557979_2679P--

