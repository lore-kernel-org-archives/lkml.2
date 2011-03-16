Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1CPR3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1CPR32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:29:28 -0400
From: Tom Tromey <tromey@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	<20110314163028.a05cec49.akpm@linux-foundation.org>
	<20110314234754.GP2499@one.firstfloor.org>
	<alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6>
	<20110315180639.GQ2499@one.firstfloor.org>
	<alpine.LFD.2.00.1103152038280.2787@localhost6.localdomain6>
	<1300219261.9910.300.camel@gandalf.stny.rr.com>
	<alpine.LFD.2.00.1103152102430.2787@localhost6.localdomain6>
X-Attribution: Tom
Date: Wed, 16 Mar 2011 11:27:38 -0600
In-Reply-To: <alpine.LFD.2.00.1103152102430.2787@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 15 Mar 2011 21:09:18 +0100 (CET)")
Message-ID: <m3sjun2cxh.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If gdb, perf, trace can and will make use of it then we have sensible
>> arguments enough to go there. If systemtap can use it as well then I
>> have no problem with that..

Yes, gdb would be able to use it.
I don't know of anybody working on it at present.

Tom
