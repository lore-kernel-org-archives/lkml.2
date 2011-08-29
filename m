Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1H2SPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:15:54 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51187 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416Ab1H2SPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:15:51 -0400
X-Sasl-enc: TGvNJ+kjmGuKOXhXRwp4opX7uICOgdiuB0Rx4sbHLlnc 1314641750
Date: Mon, 29 Aug 2011 11:15:02 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
Message-ID: <20110829181502.GC19668@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469874-7017-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:14AM -0700, K. Y. Srinivasan wrote:
> Further cleanup of the hv drivers. 
> 
> 	1) Cleanup reference counting.
> 
> 	2) Handle all block devices using the storvsc driver. I have modified
> 	   the implementation here based on Christoph's feedback on my earlier
> 	   implementation.
> 
> 	3) Fix bugs.
> 
> 	4) Accomodate some host side scsi emulation bugs.
> 
> 	5) In case of scsi errors off-line the device.
> 
> This patch-set further reduces the size of Hyper-V drivers - the code is
> about 10% smaller. This reduction is mainly because we have eliminated the
> blkvsc driver.

If my tracking is correct, I applied everything in this series except
the following patches
	[PATCH 37/46] Staging: hv: vmbus: Check for events before messages
	[PATCH 41/46] Staging: hv: vmbus: Fix a bug in error handling in vmbus_bus_init()
	[PATCH 46/46] Staging: hv: Update the TODO file

Please fix up patches 37 and 41 and resend, and for 46, that should be
totally different as mentioned, but you might want to send a patch that
at the least adds your name to the file at the bottom, as you wanted.
Also note that the MAINTAINERS file should also be adjusted to match.

thanks,

greg k-h
