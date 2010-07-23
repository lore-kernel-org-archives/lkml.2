Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab0GWQkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:40:24 -0400
Received: from verein.lst.de ([213.95.11.210]:51039 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0GWQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:40:22 -0400
Date: Fri, 23 Jul 2010 18:39:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100723163954.GA23669@lst.de>
References: <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de> <20100714151215.GA31825@lst.de> <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain> <20100714154746.GA2074@lst.de> <1279894516.3319.44.camel@gandalf.stny.rr.com> <1279895042.3319.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279895042.3319.48.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:24:02AM -0400, Steven Rostedt wrote:
> So we should do:
> 
> } __attribute__((aligned(THREAD_SIZE)));

Yes, that looks like a likely culprit.  I tried to verify it, but right
now I can't reproduce the issue anymore.  I've done another completely
clean rebuild to see if I can reproduce it again.

