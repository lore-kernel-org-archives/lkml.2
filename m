Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab1FGUx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:53:58 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37127 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151Ab1FGUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:53:57 -0400
X-Sasl-enc: BVyXOVWxXcxpcZf4AoDVNU6LypmyzcoQOBZ05oy0Ukg8 1307480036
Date: Tue, 7 Jun 2011 13:48:56 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/49] Staging: hv: Driver cleanup
Message-ID: <20110607204856.GA26016@kroah.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307400540-13193-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:49:00PM -0700, K. Y. Srinivasan wrote:
> Further cleanup of the hv drivers:
> 
> 	1) Continue to cleanup our drivers to conform to the Linux Driver
> 	   Model.
> 
> 	2) Fix some long standing bugs with regards to unloading and 
> 	   reloading the drivers - block, net and stor.
> 
> 	3) VMBUS is an ACPI enumerated device; make VMBUS an ACPI bus driver.

Ok, if that's the way the bus really is, it's good to get rid of the pci
code.

> 	4) Get rid of channel polling code; instead the channel receive paths 
> 	   will be purely interrupt drive.
> 
> 	5) Cleanup error return values in the vmbus driver and general cleanup.
> 
> 	6) Fix memory barrier calls in the ring buffer code.
> 
> 	7) Increase the timeout values for some critical guest to host calls.

I applied all of these but the last one.

For the last patch, please provide more information about it.  Should it
also go to older kernel releases to resolve issues found there?

thanks,

greg k-h
