Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0JESwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:52:07 -0400
Received: from kroah.org ([198.145.64.141]:39813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0JESwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:52:06 -0400
Date: Tue, 5 Oct 2010 11:49:25 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] prepare TI_ST to move out of staging
Message-ID: <20101005184925.GA20825@kroah.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 04:13:27PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Greg,
> 
> As suggested, the patch has been modified to set of 3 patches.
> 1. to add the new line discipline number to tty.h
> 2. rm the __KERNEL__ since the header is no more required for user-space
> 3. mv the header file to include/linux/
> 
> Please review.

Looks good, all queued up now.

So, on to moving the drivers out of the staging tree, right?  Care to
send me patches for them?  Have you gotten the bluetooth driver reviewed
yet?

thanks,

greg k-h
