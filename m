Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2BQSFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:05:42 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:18819 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2BQSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:05:41 -0500
Date: Fri, 17 Feb 2012 19:05:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 00/27] irq_domain generalization and rework
Message-ID: <20120217180538.GA11520@merkur.ravnborg.org>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <20120216145219.0f1c1b98.akpm@linux-foundation.org> <20120216232648.GM27825@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216232648.GM27825@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > /*
> >  * Please do not include this file in generic code.  There is currently
> >  * no requirement for any architecture to implement anything held
> >  * within this file.
> >  *
> >  * Thanks. --rmk
> >  */
> > 
> > A quick grep indicates that we've lost this battle ;) Is the comments
> > still true?  Should we stop discouraging inclusion of linux/irq.h? 
> > Does anyone even know that it's discouraged ;)
> 
> It's still true for any platform which hasn't been converted to genirq,
> as such a platform would not have asm/hw_irq.h.

In-tree only s390 is not using genirq.
All the rest are converted and provide hw_irq.h -
most of the new archs provide hw_irq via asm-generic so it does
not show up unless you look in the Kbuild file,.

	Sam
