Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0LPVka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:40:30 -0500
Received: from kroah.org ([198.145.64.141]:46151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0LPVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:40:29 -0500
Date: Thu, 16 Dec 2010 13:30:05 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Duncan Sands <duncan.sands@free.fr>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/6] speedtch: don't abuse struct delayed_work
Message-ID: <20101216213005.GA5781@kroah.com>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
 <1292172499-21633-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292172499-21633-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:48:18PM +0100, Tejun Heo wrote:
> speedtch directly uses the internal timer and work members of a struct
> delayed_work.  Use a separate work item and timer instead.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Duncan Sands <duncan.sands@free.fr>
> Cc: linux-usb@vger.kernel.org
> ---
> This is part of a series to remove flush_scheduled_work() usage to
> prepare for deprecation of flush_scheduled_work().  Patches in this
> series are self contained and mostly straight-forward.
> 
> Please feel free to take it into the appropriate tree, or just ack it.
> In the latter case, I'll merge the patch through the workqueue tree
> during the next merge window.

You forgot to add a "Signed-off-by:" on these patches, so I can't take
them in my tree :(

But feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to both 5/6 and 6/6 of this series and take them through your tree.

thanks,

greg k-h
