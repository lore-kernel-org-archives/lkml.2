Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1H3O2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:28:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36427 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab1H3O2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:28:49 -0400
X-Sasl-enc: e87SdnJ1IqdV94/cQoBbrJ7KdVHQn/xaW+rHcoIBQRwG 1314714528
Date: Tue, 30 Aug 2011 07:07:25 -0700
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling in
 vmbus_bus_init()
Message-ID: <20110830140725.GA16570@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-41-git-send-email-kys@microsoft.com>
 <20110829180842.GA23618@kroah.com>
 <20110830102949.GD3705@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830102949.GD3705@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 01:29:49PM +0300, Dan Carpenter wrote:
> > err3:
> > 	free_irq(irq, hv_acpi_dev);
> > err2:
> > 	bus_unregister(&hv_bus);
> > err1:
> > 	hv_cleanup();
> 
> Also here is an oldbie trick.  You could use multiples of ten like
> err30, err20, and err10.  That way if you can add more error handling
> in the middle without changing the numbering.  I knew my GW-BASIC
> experience would come in handy one day.  :)
> 
> The better way to label things is based on what happens when you get
> there: err_irq, err_unregister, err_cleanup.

Yes, that's the best way to do this, thanks for pointing it out.

greg k-h
