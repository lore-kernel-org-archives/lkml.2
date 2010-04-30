Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0D3Tlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:41:31 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56723 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab0D3TlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:41:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow multiple splats
In-Reply-To: Your message of "Fri, 30 Apr 2010 11:33:34 EDT."
             <20100430153334.GA19672@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <20100421200150.GA3818@linux.vnet.ibm.com> <20100430100749.GC14202@elte.hu>
            <20100430153334.GA19672@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272644205_4026P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Apr 2010 12:16:45 -0400
Message-ID: <10035.1272644205@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4BDB026E.01C0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272644205_4026P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Apr 2010 11:33:34 EDT, Mathieu Desnoyers said:

> I recommend creating a kernel command line parameter that would tweak
> the number of messages printed by lockdep. The default would indeed by 1
> message, but people in a debugging marathon can specify a larger value
> so they won't have to reboot between each individual lockdep error.

Yeah, that would rock for development kernels - playing whack-a-mole with
a half-dozen new lockdep whinges can easily stretch out for quite some time.

--==_Exmh_1272644205_4026P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL2wJtcC3lWbTT17ARAtgTAKCvJWe4IdjfLjp1nzQDe+S15USUOwCdGi/8
9q+05y+OVOYMTqf9Yo9jqEA=
=vFvr
-----END PGP SIGNATURE-----

--==_Exmh_1272644205_4026P--

