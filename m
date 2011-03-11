Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1CKCC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:02:57 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:51291 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1CKCC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:02:56 -0500
Date: Fri, 11 Mar 2011 03:02:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
Message-ID: <20110311020234.GA24634@linux-mips.org>
References: <cover.1299702291.git.jbaron@redhat.com>
 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
 <1299790895.15854.419.camel@gandalf.stny.rr.com>
 <20110310211801.GB4058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310211801.GB4058@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:18:01PM -0500, Jason Baron wrote:

> > I'm curious, is there a reason for this header change? Clean up? Maybe
> > it could go into a separate patch. If anything, just to make this one
> > slightly smaller.
> > 
> 
> hmm...I did that to get types.h for the new atomic_t usage.
> 
> However, now that I look at it again its bogus. The right fix is to
> explicitly include <linux/types.h> from jump_label.h.

And <linux/compiler.h> for unlikely().

  Ralf
