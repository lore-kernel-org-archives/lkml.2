Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2F2M6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:58:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47546 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2F2M6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:58:50 -0400
Date: Fri, 29 Jun 2012 14:58:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kay Sievers <kay@vrfy.org>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: cosmetic printk() issue with lockdep warning in
 arch/x86/kernel/alternative.c
Message-ID: <20120629125845.GA32730@gmail.com>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
 <20120627060939.GD14913@gmail.com>
 <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
 <1340795162.10063.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340795162.10063.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-06-27 at 12:49 +0200, Kay Sievers wrote:
> > All we want is a reliable printk
> 
> We too, but we define reliable differently. I want printk() to 
> dump data ASAP so that it has better chance to get out of the 
> system and onto my console in case of a crash. I don't give a 
> rats arse about interleaved text, any text is better than no 
> text.

I actually *fixed* bugs in the past when I saw interleaved text 
printed from multiple CPUs, it told me how narrow and SMP 
dependent a particular race/crash was.

So even interleaving, although annoying most of the time, can be 
useful in some other places.

Thanks,

	Ingo
