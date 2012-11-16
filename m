Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2KPMqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:46:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:45526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2KPMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:46:21 -0500
Date: Fri, 16 Nov 2012 04:47:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: core: move dwc3_cache_hwparams before
 dwc3_alloc_event_buffers
Message-ID: <20121116124711.GA14886@kroah.com>
References: <1353047874-4981-1-git-send-email-kishon@ti.com>
 <20121116081719.GA16568@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116081719.GA16568@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:17:19AM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Nov 16, 2012 at 12:07:54PM +0530, Kishon Vijay Abraham I wrote:
> > commit 392142 moved event buffer allocation out of dwc3_core_init() but
> > event buffer allocation uses the cached copy of hwparams to determine
> > the number of event buffers and the caching is done in dwc3_core_init.
> > So moved dwc3_cache_hwparams function before dwc3_alloc_event_buffers so
> > that dwc3_alloc_event_buffers sees the correct number of event buffers.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> My bad, what a regression I caused :-)
> 
> Greg, can you take this one ?

Yes, will do.

