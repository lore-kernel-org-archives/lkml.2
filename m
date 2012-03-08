Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2CHGQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:16:24 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:25415 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2CHGQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:16:22 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHjS0PFKx8
X-RZG-CLASS-ID: mo00
Date: Thu, 8 Mar 2012 07:16:16 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <greg@kroah.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120308061615.GA25237@aepfle.de>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307201746.GA20900@aepfle.de>
 <20120307204946.GA4413@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120307204946.GA4413@kroah.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, Greg KH wrote:

> On Wed, Mar 07, 2012 at 09:17:46PM +0100, Olaf Hering wrote:
> > On Wed, Mar 07, Haiyang Zhang wrote:
> > 
> > 
> > > @@ -482,7 +484,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
> > >  
> > >  /* The one and only one */
> > >  static struct  hv_driver netvsc_drv = {
> > > -	.name = "netvsc",
> > > +	.name = MODULE_NAME,
> > 
> > It would be nice if this could be applied to 3.3.
> > hv_storvsc and hid-hyperv already use the same naming, this patch was
> > send last year already but was not applied for some reason.
> 
> What userspace tools depend on this that requires it to be in 3.3?

It represents the module names, at least for pci and other bus types.
hwinfo uses it to recognize a network interface (storage in case of
hv_storvsc).

Olaf
