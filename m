Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1ELTHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:07:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab1ELTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:07:32 -0400
Date: Thu, 12 May 2011 12:06:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] genalloc: add support to specify the physical
 address
Message-Id: <20110512120643.67e7929d.akpm@linux-foundation.org>
In-Reply-To: <20110512173832.GA8633@n2100.arm.linux.org.uk>
References: <1303282455-26649-1-git-send-email-plagnioj@jcrosoft.com>
	<20110428081535.GI17290@n2100.arm.linux.org.uk>
	<20110512173832.GA8633@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 18:38:32 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Apr 28, 2011 at 09:15:35AM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 20, 2011 at 08:54:15AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > so we specify the virtual address as base of the pool chunk and then
> > > get the physical address for hardware IP
> > > 
> > > as example on at91 we will use on spi, uart or macb
> > > 
> > > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > Hi Andrew,
> > > 	I integrate the documentation fix
> > > 	could replace the previous one with this one
> > > 
> > > V2:
> > > 	update documentation
> > > 	use phys_addr_t for physical addr
> > > Best Regards,
> > 
> > I notice no comments on this - maybe it needs to be Cc'd to linux-mm too?
> > 
> > Andrew - do you have any views on this?
> 
> Still haven't heard anything.  What's the status?

Sorry, I missed the earlier email.  I've had v2 queued for 2.6.39 for a
month.  If someone merges it into some other tree then that's OK by me
- I'll just drop my copy when it turns up in -next.

