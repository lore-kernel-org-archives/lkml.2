Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab2COO5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:57:50 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64383 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2COO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:57:47 -0400
Date: Thu, 15 Mar 2012 07:57:43 -0700
From: gregkh <gregkh@linuxfoundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120315145743.GA7928@kroah.com>
References: <1331787186.2979.71.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331787186.2979.71.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:53:06PM +0800, Alex Shi wrote:
> 
> According to Felipe and Alan's comments the second parameter of irq
> handler should be 'void *' not a specific structure pointer. 
> So change it.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  drivers/usb/host/xhci.c      |    4 ++--
>  drivers/usb/host/xhci.h      |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Is this needed in my -next tree now?  Or is it something for later?

Any reason you did not put Sarah on the To: line here?  She's the one
that needs to ack it before I can accept it.

thanks,

greg k-h
