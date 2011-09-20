Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1ITWUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:20:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34142 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1ITWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:20:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Christoph Lameter <cl@gentwo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: Your message of "Tue, 20 Sep 2011 10:54:10 CDT."
             <alpine.DEB.2.00.1109201038150.8056@router.home>
From: Valdis.Kletnieks@vt.edu
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home> <1316476089.29966.9.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1109200940240.8056@router.home> <1316531769.29966.61.camel@gandalf.stny.rr.com>
            <alpine.DEB.2.00.1109201038150.8056@router.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316557142_2679P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Sep 2011 18:19:02 -0400
Message-ID: <25631.1316557142@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E791168.00C1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316557142_2679P
Content-Type: text/plain; charset=us-ascii

On Tue, 20 Sep 2011 10:54:10 CDT, Christoph Lameter said:
> IT DOES!!!! The memcg bug is caused by someone using this_cpu_read and
> expecting the cpu not to change. this_cpu_xx ops stand on their own and do
> not guarantee access to the same per cpu area.

As most 6 year olds will tell you, "Well, DUH!".  Maybe if you had called it
"this_cpu_or_maybe_that_one_over_there_read()", people wouldn't use it wrong.

"If people place a nice chocky in their mouth, they don't want their cheeks
pierced. In any case this is an inadequate description of the sweetmeat. I
shall have to ask you to accompany me to the station." -- Monty Python.

"inadequate description" hardly begins to cover the design of this API, which
definitely needs to be taken to the station.


--==_Exmh_1316557142_2679P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOeRFWcC3lWbTT17ARAmB6AJ9AmXFl+zQUScH2FgyoY3gQcAqp0wCcD13c
xHluKi7tYJbPbcxhaixSYTI=
=I0Qc
-----END PGP SIGNATURE-----

--==_Exmh_1316557142_2679P--

