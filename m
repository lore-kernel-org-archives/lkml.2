Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1AWTjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 14:39:42 -0500
Received: from kroah.org ([198.145.64.141]:60722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1AWTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 14:39:40 -0500
Date: Mon, 24 Jan 2011 04:40:48 +0900
From: Greg KH <greg@kroah.com>
To: merez@codeaurora.org
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v4] usb: Add streams support to the gadget
 framework.
Message-ID: <20110123194048.GA8954@kroah.com>
References: <1295523914-20056-1-git-send-email-merez@codeaurora.org>
 <20110120163811.GB30680@kroah.com>
 <e146c388999f324ac94d72d35d4fa656.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e146c388999f324ac94d72d35d4fa656.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 11:34:19AM -0800, merez@codeaurora.org wrote:
> > On Thu, January 20, 2011 8:38 am, Greg KH wrote:
> > Why?  What in-kernel code needs this?
> > Again, why?
> Both chnages are required for the UASP device driver
> (http://marc.info/?t=129559592400001&r=1&w=2).

Then PLEASE say that.  How am I supposed to know this?

Just make this patch part of that series.  We dont add apis to the
kernel unless there is a user of it, so it will not be accepted until
those other patches are also accepted.

thanks,

greg k-h
