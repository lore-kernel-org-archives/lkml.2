Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1HWX3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:29:39 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60350 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028Ab1HWX2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:09 -0400
X-Sasl-enc: LM0ZwmrXa4g7x9AyEMN93h00bcIxu+SnjZkf9N8snaX3 1314142088
Date: Tue, 23 Aug 2011 16:11:20 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 0000/0117] Staging: hv: Driver cleanup
Message-ID: <20110823231120.GP9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752024-27854-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:47:04AM -0700, K. Y. Srinivasan wrote:
> Further cleanup of the hv drivers. Back in June I had sent two patch
> sets to address these issues. I have addressed the comments I got from
> the community on my earlier patches here:
> 
> 	1) Implement code for autoloading the vmbus drivers without using PCI or DMI
> 	   signatures. I have implemented this based on Greg's feedback on my earlier
> 	   implementation.
> 
> 	2) Cleanup error handling across the board and use standard Linux error codes.
> 
> 	3) General cleanup
> 
> 	4) Some bug fixes.
> 
> 	5) Cleanup the reference counting mess for both stor and net devices.
> 
> 	6) Handle all block devices using the storvsc driver. I have modified
> 	   the implementation here based on Christoph's feedback on my earlier
> 	   implementation.
> 
> 	7) Accomodate some host side scsi emulation bugs.
> 
> 	8) In case of scsi errors off-line the device.

Care to respin this patch series based on my comments?

thanks,

greg k-h
