Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1KXGuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:50:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38886 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1KXGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:49:59 -0500
Date: Thu, 24 Nov 2011 12:18:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, tulasidhard@gmail.com,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>
Subject: Re: Fwd: uprobes: register/unregister probes.
Message-ID: <20111124064853.GA28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <hYuXv-26J-3@gated-at.bofh.it>
 <hYuXw-26J-5@gated-at.bofh.it>
 <i0o1A-7sd-9@gated-at.bofh.it>
 <fe077f71-dce6-40cf-988c-cc35bf4c7ae1@o11g2000prg.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe077f71-dce6-40cf-988c-cc35bf4c7ae1@o11g2000prg.googlegroups.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112406-3352-0000-0000-000000F52980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > +#define UPROBES_HASH_SZ        13
> > +/* serialize (un)register */
> > +static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
> > +#define uprobes_hash(v)        (&uprobes_mutex[((unsigned long)(v)) %\
> > +                                               UPROBES_HASH_SZ])
> 
> Was there any reason to for using this hasing scheme, say over hash.h?

There is no specific reason for choosing this hashing scheme over the
current. I just say ext4_aio_mutex in fs/ext4/ext4.h and did something
similar.

-- 
Thanks and Regards
Srikar

