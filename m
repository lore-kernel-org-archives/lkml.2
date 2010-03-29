Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0C2VHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:07:00 -0400
Received: from kroah.org ([198.145.64.141]:37743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0C2VG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:06:59 -0400
Date: Mon, 29 Mar 2010 14:07:22 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH 2.6.29.x - 2.6.31.1] module: fix
	__module_ref_addr()
Message-ID: <20100329210722.GA14993@kroah.com>
References: <20100327143126.GA25615@Krystal> <1269890492.19685.4767.camel@gandalf.stny.rr.com> <20100329200946.GA1618@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329200946.GA1618@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 04:09:46PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > This patch does not apply to 2.6.34-rc, and the code in upstream looks
> > to have been fixed. Should this go to stable?
> 
> Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
> -stable.

Why is this not in .34-rc2?  Can you find the specific patch in Linus's
tree that solves this and let stable@kernel.org know about it?

thanks,

greg k-h
