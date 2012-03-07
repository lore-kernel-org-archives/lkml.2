Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2CGUtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:49:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40178 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757073Ab2CGUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:49:48 -0500
X-Sasl-enc: H4FKpkwsFvGvcmP7qcsKopZ+9wR5k7WlS2DpJ2naGoIz 1331153387
Date: Wed, 7 Mar 2012 12:49:46 -0800
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120307204946.GA4413@kroah.com>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307201746.GA20900@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307201746.GA20900@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:17:46PM +0100, Olaf Hering wrote:
> On Wed, Mar 07, Haiyang Zhang wrote:
> 
> 
> > @@ -482,7 +484,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
> >  
> >  /* The one and only one */
> >  static struct  hv_driver netvsc_drv = {
> > -	.name = "netvsc",
> > +	.name = MODULE_NAME,
> 
> It would be nice if this could be applied to 3.3.
> hv_storvsc and hid-hyperv already use the same naming, this patch was
> send last year already but was not applied for some reason.

What userspace tools depend on this that requires it to be in 3.3?

greg k-h
