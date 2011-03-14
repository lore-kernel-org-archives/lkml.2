Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1CNXr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:47:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35008 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1CNXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:47:55 -0400
Date: Tue, 15 Mar 2011 00:47:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20]  0: Inode based uprobes
Message-ID: <20110314234754.GP2499@one.firstfloor.org>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314163028.a05cec49.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314163028.a05cec49.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IOW, I'm trying to get an understanding of how you expect this feature
> will actually become useful to end users - the kernel patch is only
> part of the story.

One user would be systemtap for user tracing as I understand. Systemtap has a 
userbase (at least I use it, although not for user tracing)

Right now lots of distros apply ugly patchkits to handle this instead,
which is not good (tm).

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
