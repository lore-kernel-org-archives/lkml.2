Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1DUMDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:03:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53552 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1DUMDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:03:52 -0400
Date: Thu, 21 Apr 2011 17:19:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 18/26] 18: uprobes: commonly used
 filters.
Message-ID: <20110421114936.GF10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143602.15455.82211.sendpatchset@localhost6.localdomain6>
 <1303221477.8345.6.camel@twins>
 <20110421110911.GE10698@linux.vnet.ibm.com>
 <1303385835.2035.75.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303385835.2035.75.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-04-21 13:37:15]:

> On Thu, 2011-04-21 at 16:39 +0530, Srikar Dronamraju wrote:
> > > What you want is to save the pid-namespace of the task creating the
> > > filter in your uprobe_simple_consumer and use that to obtain the task's
> > > pid for matching with the provided number.
> > > 
> > 
> > Okay, will do by adding the pid-namespace of the task creating the
> > filter in the uprobe_simple_consumer. 
> 
> Maybe you could convert to the global pid namespace on construction and
> always use that for comparison.
> 
> That would avoid the namespace muck on comparison.. 
> 

Yeah, this idea also seems feasible.

-- 
Thanks and Regards
Srikar
