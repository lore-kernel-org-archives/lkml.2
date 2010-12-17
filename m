Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0LQTe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:34:29 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43976 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0LQTe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:34:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 18/20] 18: uprobes: commonly used filters.
In-Reply-To: Your message of "Thu, 16 Dec 2010 15:30:49 +0530."
             <20101216100049.23751.2658.sendpatchset@localhost6.localdomain6>
From: Valdis.Kletnieks@vt.edu
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
            <20101216100049.23751.2658.sendpatchset@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1292614379_5427P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Dec 2010 14:32:59 -0500
Message-ID: <51253.1292614379@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4D0BBAEF.0035,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1292614379_5427P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Dec 2010 15:30:49 +0530, Srikar Dronamraju said:

> Provides most commonly used filters. Prevents users from having to define
> their own filters. However this would be useful once we can
> dynamically associate a filter with a uprobe-event tracer.

Unclear/awkward language here...

Did you mean "Prevents users from defining their own filters" or "Allows
users to not have to define their own filters"?

--==_Exmh_1292614379_5427P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNC7rrcC3lWbTT17ARAlNTAJ9uq4rg9D7GMbPo+hK8447gjk+2JwCaA4oS
xZ+fbPNfA5DzHB/mTcd6r6g=
=1SgE
-----END PGP SIGNATURE-----

--==_Exmh_1292614379_5427P--

