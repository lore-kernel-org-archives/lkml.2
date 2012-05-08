Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2EHIb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:31:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:43056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2EHIbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:31:53 -0400
Message-ID: <1336465808.16236.13.camel@twins>
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface for
 uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Tue, 08 May 2012 10:30:08 +0200
In-Reply-To: <20120508041229.GD30652@gmail.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
	 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
	 <20120411103043.GB29437@linux.vnet.ibm.com>
	 <20120508041229.GD30652@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 06:12 +0200, Ingo Molnar wrote:
> FYI, this warning started to trigger in -tip, with the latest 
> uprobes patches:
> 
> warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENTS && PERF_EVENTS)

this looks to be the only UPROBE_EVENTS instance, is that a typo?

---
 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9e2fbb5..c160d92 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -78,7 +78,7 @@ config OPTPROBES
 
 config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on UPROBE_EVENTS && PERF_EVENTS
+	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
 	help
 	  Uprobes is the user-space counterpart to kprobes: they

