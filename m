Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0JKUZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab0JKUZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:25:47 -0400
Date: Mon, 11 Oct 2010 16:25:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf, x86: Fix accidentally ack'ing a second
 event on intel perf counter
Message-ID: <20101011202528.GA24567@redhat.com>
References: <1283454469-1909-2-git-send-email-dzickus@redhat.com>
 <tip-2e556b5b320838fde98480a1f6cf220a5af200fc@git.kernel.org>
 <4C80A62D.6050901@kernel.org>
 <20100903150055.GY4879@redhat.com>
 <4C812D24.8000704@kernel.org>
 <20100903183559.GB4879@redhat.com>
 <4CAA621E.7040403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAA621E.7040403@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 04:24:14PM -0700, Yinghai Lu wrote:
> >  	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
> > +#if defined(CONFIG_SYSCTL) && defined(CONFIG_X86_LOCAL_APIC)
> > +	if (unknown_nmi_panic)
> > +		die_nmi("", regs, 1);
> > +#endif
> >  	if (panic_on_unrecovered_nmi)
> >  		panic("NMI: Not continuing");
> 
> please consider to move 
> 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
> down.
> 
> test it, and it works on my test setups.
> 
> please submit complete patch to Ingo.

I think Huang Ying from Intel has a patchset with similar changes.  I'll
have him make the changes.

Cheers,
Don
