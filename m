Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DZX3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:29:53 -0400
Received: from kroah.org ([198.145.64.141]:51143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1DZX3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:29:52 -0400
Date: Tue, 26 Apr 2011 16:28:43 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110426232843.GA31184@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303834785-4981-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:19:45AM -0700, K. Y. Srinivasan wrote:
> This patch-set addresses some of the bus/driver model cleanup that
> Greg sugested over the last couple of days.  In this patch-set we
> deal with the following issues:
> 
> 	1) Cleanup unnecessary state in struct hv_device and 
> 	   struct hv_driver to be compliant with the Linux
> 	   Driver model.
> 
> 	2) Cleanup the vmbus_match() function to conform with the 
> 	   Linux Driver model.
> 
> 	3) Cleanup error handling in the vmbus_probe() and 
> 	   vmbus_child_device_register() functions. Fixed a 
> 	   bug in the probe failure path as part of this cleanup.
> 
> 	4) The Windows host cannot handle the vmbus_driver being 
> 	   unloaded and subsequently loaded. Cleanup the driver with
> 	   this in mind.

I've stopped at this patch (well, I applied one more, but you can see
that.)

I'd like to get some confirmation that this is really what you all want
to do here before applying it.  If it is, care to resend them with a bit
more information about this issue and why you all are making it?

Anyway, other than this one, the series looks good.  But you should
follow-up with some driver structure changes like what Christoph said to
do.  After that, do you want another round of review of the code, or do
you have more things you want to send in (like the name[64] removal?)

thanks,

greg k-h
