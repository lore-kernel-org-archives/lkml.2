Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1CNTjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:39:01 -0400
Received: from kroah.org ([198.145.64.141]:38756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1CNTi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:38:59 -0400
Date: Mon, 14 Mar 2011 12:37:16 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/21] Staging: hv: Cleanup vmbus driver
Message-ID: <20110314193716.GA22131@kroah.com>
References: <1299794382-709-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299794382-709-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:59:42PM -0800, K. Y. Srinivasan wrote:
> This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):
> 
> Cleanup root device management: (patches 1/21 through 10/21)
> 	1) Get rid of the hv_driver code from the vmbus abstraction
> 	2) Get rid of unnecessary call sequences and functions
> 	3) Cleanup the management of the root device by using the 
> 	   standard mechanism for grouping devices under /sys/devices

I've applied the first 9 patches, as I had questions on 10 and 11, and
the others after that don't apply without those two applied.

So, care to resend the rest of the series when we've figured out the
root device stuff?

thanks,

greg k-h
