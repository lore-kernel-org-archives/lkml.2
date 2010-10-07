Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0JGR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:56:18 -0400
Received: from kroah.org ([198.145.64.141]:34009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0JGR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:56:14 -0400
Date: Thu, 7 Oct 2010 10:51:03 -0700
From: Greg KH <greg@kroah.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
Message-ID: <20101007175103.GA31639@kroah.com>
References: <1286423526-2777-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286423526-2777-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 09:22:06AM +0530, Rahul Ruikar wrote:
> Fix for following cases
> - Call device_unregister() only when device_register() succeeds.
> - Call put_device() when device_register() fails.
> - Call device_remove_file() only when device_create_file() succeeds.
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/langwell_udc.c |   14 +++++++++++---
>  drivers/usb/gadget/langwell_udc.h |    4 +++-
>  2 files changed, 14 insertions(+), 4 deletions(-)

This patch doesn't apply at all to my tree.  Can you redo it against the
latest linux-next release?

thanks,

greg k-h
