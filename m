Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2CHRmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:42:24 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44439 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab2CHRmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:42:22 -0500
X-Sasl-enc: CTK/Gyg9Kb+SiqXC3rPy2cZLwPZEGqzmKEjBXI4s4blt 1331228541
Date: Thu, 8 Mar 2012 09:42:20 -0800
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120308174220.GB17192@kroah.com>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307201746.GA20900@aepfle.de>
 <20120307204946.GA4413@kroah.com>
 <20120308061615.GA25237@aepfle.de>
 <20120308155219.GC5907@kroah.com>
 <20120308161221.GA31415@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308161221.GA31415@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 05:12:21PM +0100, Olaf Hering wrote:
> On Thu, Mar 08, Greg KH wrote:
> 
> > > hwinfo uses it to recognize a network interface (storage in case of
> > > hv_storvsc).
> > 
> > That tool should report the real module name, not rely on the name to
> > match based on the structure, if you really care about the real module
> > name.
> 
> Its about the driver symlink, not the module name. 
> 
> I think most, if not all, (relevant) drivers use some sort of
> KBUILD_MODNAME. Why should this driver be any different?

It shouldn't, I'm not saying that at all.  I'm only objecting to the
insistance that this be something worthwhile for 3.3-final which should
be out any day now.

greg k-h
