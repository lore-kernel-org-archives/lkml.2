Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1ELRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:39:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48749 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab1ELRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:39:35 -0400
Date: Thu, 12 May 2011 18:38:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] genalloc: add support to specify the physical
	address
Message-ID: <20110512173832.GA8633@n2100.arm.linux.org.uk>
References: <1303282455-26649-1-git-send-email-plagnioj@jcrosoft.com> <20110428081535.GI17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428081535.GI17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:15:35AM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 20, 2011 at 08:54:15AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > so we specify the virtual address as base of the pool chunk and then
> > get the physical address for hardware IP
> > 
> > as example on at91 we will use on spi, uart or macb
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > Hi Andrew,
> > 	I integrate the documentation fix
> > 	could replace the previous one with this one
> > 
> > V2:
> > 	update documentation
> > 	use phys_addr_t for physical addr
> > Best Regards,
> 
> I notice no comments on this - maybe it needs to be Cc'd to linux-mm too?
> 
> Andrew - do you have any views on this?

Still haven't heard anything.  What's the status?

If this isn't going into mainline, I'll queue up my work consolidating
the existing ARM sram allocators instead, and when this hits we can see
about moving stuff over to it then.
