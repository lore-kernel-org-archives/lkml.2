Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1KWTu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:50:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1KWTuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:50:25 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=DLYqgWQrQG4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=gvrx8skBgqkb9WqecwgA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
In-Reply-To: <1322072149.14799.89.camel@twins>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
	 <1322072149.14799.89.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 14:50:19 -0500
Message-ID: <1322077819.20742.69.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 19:15 +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > @@ -545,8 +547,14 @@ again:                     remove_next = 1 + (end > next->vm_end);
> 
> I'm not sure if you use quilt or git to produce these patches but can
> you either add:
> 
> QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"
> 
> to your .quiltrc, or:
> 
> [diff "default"]
>                 xfuncname = "^[[:alpha:]$_].*[^:]$"
> 
> to your .gitconfig ?
> 

or just place a space in front of "again:"

/me runs!

-- Steve


