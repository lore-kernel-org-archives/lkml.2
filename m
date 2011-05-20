Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1ETNEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:04:32 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53544 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab1ETNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:04:30 -0400
X-Sasl-enc: HcJMGgHECzHqsRvgRtOuXomc0T2b3D31LAnQGjv5VHVD 1305896669
Date: Fri, 20 May 2011 06:05:27 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: vmbus driver
Message-ID: <20110520130527.GB10033@kroah.com>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305842785-30206-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:06:25PM -0700, K. Y. Srinivasan wrote:
>  
> Greg,
> 
> A few days ago you applied all the outstanding patches for the Hyper-V
> drivers. With these patches, I have addressed all of the known review 
> comments for the  vmbus driver (and a lot of comments/issues in other
> drivers as well). I am still hoping I can address 
> whatever other issues/comments there might be with the intention to 
> get the vmbus driver out of staging in the current window. What is your 
> sense in terms of how feasible this is. From my side, I can assure you 
> that I will address all legitimate issues in a very timely manner and this
> will not be dependent upon the location of the drivers (staging or 
> outside staging). Looking forward to hearing from you.

The merge window is closed now, and I'm on the road in asia for about 3
weeks, so doing this, at this point in the development cycle, is going
to be hard.

I'll go review the bus code again after the code is all merged with
Linus, which should take a week or so depending on my schedule, and let
you know what's left to do (I think there still is something wierd with
the way the hv_driver is structured, but I could be wrong.)

In the mean time, I'm sure the block and network driver still need a lot
of work, and merging the bus code doesn't make much sense without them
as a user as that is what people really want to use, so you can continue
to work on them.

thanks,

greg k-h
