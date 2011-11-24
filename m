Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1KXOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:43:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51295 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1KXOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:43:20 -0500
Date: Thu, 24 Nov 2011 20:09:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
Message-ID: <20111124143952.GJ28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
 <1322064540.14799.78.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322064540.14799.78.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112414-5112-0000-0000-0000025E1F93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +                       ret = 0;
> > +               if (!ret)
> > +                       break;
> 
> Shouldn't that read:
> 		if (ret)
> 			break;
> 
> So that we bail when there's a real error instead of no error?
> 

Right, will fix this and also do the PTR_ERR changes that you suggested.

-- 
thanks and regards
Srikar

