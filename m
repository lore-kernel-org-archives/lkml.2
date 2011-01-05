Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab1AEGhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:37:31 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42668 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1AEGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:37:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
In-Reply-To: Your message of "Wed, 05 Jan 2011 04:10:18 +0100."
             <20110105031016.GI2911@nowhere>
From: Valdis.Kletnieks@vt.edu
References: <20110104231629.996422888@efficios.com> <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere> <20110105001837.GA9737@Krystal> <20110105020759.GG2911@nowhere> <12932.1294196493@localhost>
            <20110105031016.GI2911@nowhere>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294209428_4845P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Jan 2011 01:37:08 -0500
Message-ID: <20754.1294209428@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4D241197.008D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294209428_4845P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Jan 2011 04:10:18 +0100, Frederic Weisbecker said:
> On Tue, Jan 04, 2011 at 10:01:33PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > Can DEFINE_EVENT ever be sensibly used in a context where the additional ; will
> > cause an issue (for instance, a hypothetical array initialization like:
> >
> > static struct events[] = {DEFINE_EVENT(..), DEFINE_EVENT(...) }

> You can't do the above as DEFINE_EVENT() do more than just creating a structure.
> It can define functions and so.
>
> Plus it doesn't behave the same whether CREATE_TRACE_POINTS is defined or not:
> it can either define or declare the functions and structures.
>
> > or other places we usually do the 'do { X } while (0)' trick to make the code legal?
>
> I just can't figure out a sane case.

OK..  I was wondering if there was a corner case where we had to resolve the
one versus two semicolon issue in a specific way to guarantee syntactic
correctness, but it looks like this one gets to fight it out on taste/style
grounds...


--==_Exmh_1294209428_4845P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNJBGUcC3lWbTT17ARAo52AJ0bvazjMDFKGozXBG61+ve54UDtnwCgpPWX
U6UFVuPfFtZr5v/Yyh5SPVo=
=g7Fz
-----END PGP SIGNATURE-----

--==_Exmh_1294209428_4845P--

