Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1HWX3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:29:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56435 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067Ab1HWX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:14 -0400
X-Sasl-enc: VXYSRHKLESE+1EL+ik6F5Xtf2M7GzAzgZmcCLxfYtrOM 1314142093
Date: Tue, 23 Aug 2011 16:18:50 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 0/8] Staging: hv: vmbus: Driver cleanup
Message-ID: <20110823231850.GD9955@kroah.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313446210-10611-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 03:10:10PM -0700, K. Y. Srinivasan wrote:
> Further cleanup of the vmbus driver:
> 
> 	1) Cleanup the interrupt handler by inlining some code. 
> 
> 	2) Ensure message handling is performed on the same CPU that
> 	   takes the vmbus interrupt. 
> 
> 	3) Check for events before messages (from the host).
> 
> 	4) Disable auto eoi for the vmbus interrupt since Linux will eoi the
> 	   interrupt anyway. 
> 
> 	5) Some general cleanup.

As I didn't apply your other changes, care to respin all of your
outstanding hv patches against the next linux-next release and resend
them?  I tried picking some of the other patches, but they started not
applying easily so it would be easier for everyone to just resend them
after you fix them up.

thanks,

greg k-h
