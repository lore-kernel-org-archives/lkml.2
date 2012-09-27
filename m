Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2I0Jnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:43:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:13355 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2I0Jnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="197850085"
Message-ID: <1348739022.13371.157.camel@smile>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Thu, 27 Sep 2012 12:43:42 +0300
In-Reply-To: <1348735450.1648.5.camel@vkoul-udesk3>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348735450.1648.5.camel@vkoul-udesk3>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 14:14 +0530, Vinod Koul wrote: 
> > +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> > +				  const struct pci_device_id *id)
> > +{
> ...
> > +
> > +	pd = platform_device_alloc("dw_dmac", instance);
> Why can't the core driver library be agnostic. Why do we care if the
> device is platform, pci or something else. 
> There is nothing in dma API callbacks which driver implements that
> warrants it to be some device.
> 
> You have already taken care of dma controller accesses be arch
> independent so I don't see a reason why this should be done?
I'm afraid I didn't get you comment.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
