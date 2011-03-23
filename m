Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1CWVYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1CWVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:24:13 -0400
Date: Wed, 23 Mar 2011 17:23:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110323212358.GC29184@redhat.com>
References: <20110321182235.GA14562@sgi.com>
 <20110321193740.GN1239@redhat.com>
 <20110322171118.GA6294@sgi.com>
 <20110322184450.GU1239@redhat.com>
 <20110322212519.GA12076@sgi.com>
 <20110322220505.GB13453@redhat.com>
 <20110323163255.GA17178@sgi.com>
 <20110323175320.GB9413@redhat.com>
 <20110323200008.GZ1239@redhat.com>
 <20110323204647.GA30938@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323204647.GA30938@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:46:47PM -0500, Jack Steiner wrote:
> On Wed, Mar 23, 2011 at 04:00:08PM -0400, Don Zickus wrote:
> > On Wed, Mar 23, 2011 at 01:53:20PM -0400, Don Zickus wrote:
> > > Let me know if the patch fixes that problem.  Then it will be one less
> > > thing to worry about. :-)
> > 
> > Ok, I was an idiot and made the patch against RHEL-6.  Here is the one
> > against 2.6.38.  Sorry about that.
> 
> No problem.
> 
> I applied the patch below. However, I still see the "dazed" messages with
> about the same frequency.

Crap.  It fixed acme's problem though where he was using 3 counters at
high frequency.  The problem must be elsewhere.  I'll have to figure out a
new strategy.  I'll probably put together a patch full of trace_printk
output to see if I can characterize it.

Cheers,
Don
