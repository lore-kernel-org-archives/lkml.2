Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0IHCXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:23:15 -0400
Received: from kroah.org ([198.145.64.141]:33930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab0IHCXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:23:13 -0400
Date: Tue, 7 Sep 2010 19:19:39 -0700
From: Greg KH <greg@kroah.com>
To: tom.leiming@gmail.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND/PATCH 0/6] USB: musb-gadget: bug fix
Message-ID: <20100908021939.GA20443@kroah.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 11:23:28PM +0800, tom.leiming@gmail.com wrote:
> This patch set fixes two kinds of musb-gadget bug:
> 
> 	-fix kernel panic if using out ep with FIFO_TXRX style
> 
> 	-make double buffer mode usable, fix infinate hangs and buffer
> 	corrupt bug when using double buffer mode to do data transfer;
> 	now we can use musb double buffer reliably, so bootst performance
> 	about 30% compared with single buffer mode.
> 	
> 		[RESEND/PATCH 1/6] USB: musb-gadget: fix kernel panic if using out ep with FIFO_TXRX style(v1)
> 		[RESEND/PATCH 2/6] USB: musb-gadget: fix bulk IN infinite hangs in double buffer case
> 		[RESEND/PATCH 3/6] USB: musb-gadget: enable autoclear for OUT transfer in both DMA 0 and DMA 1
> 		[RESEND/PATCH 4/6] USB: musb-gadget: fix DMA length for OUT transfer
> 		[RESEND/PATCH 5/6] USB: musb-gadget: complete request only if data is transfered over
> 		[RESEND/PATCH 6/6] USB: musb-gadget: fix dma length in txstate

I seem to not have 1/6 here, did it get stuck somewhere?

Anyway, I need Felipe's ack before I can accept these.

thanks,

greg k-h
