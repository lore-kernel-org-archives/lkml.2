Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1KIQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:56:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51982 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602Ab1KIQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:56:22 -0500
X-Sasl-enc: HmhtPJ/RQF8KAuoNCXqwREgi76yuEnxcxbpLiT+/pCF3 1320857781
Date: Wed, 9 Nov 2011 08:55:18 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109165518.GA13451@kroah.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109164211.GA4016@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 04:42:12PM +0000, Mark Brown wrote:
> On Wed, Nov 09, 2011 at 09:30:13PM +0530, Vinod Koul wrote:
> 
> > Alan, if you folks are not using the staging driver I am okay for its
> > removal
> 
> Someone will need to fix the build breakage from peering at the headers
> from staging.

What code is including header files from the staging tree in the rest of
the kernel?

greg k-h
