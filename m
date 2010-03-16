Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0CPVj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:39:57 -0400
Received: from kroah.org ([198.145.64.141]:44881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0CPVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:39:55 -0400
Date: Tue, 16 Mar 2010 14:40:14 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alex Chiang <achiang@hp.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100316214014.GA8839@kroah.com>
References: <20100316204845.GJ8278@ldl.fc.hp.com> <20100309184723.GA31374@kroah.com> <20100316212445.GA15729@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316212445.GA15729@xanatos>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 02:24:45PM -0700, Sarah Sharp wrote:
> Ok, I didn't see Greg's email about dynamic debugging.  I guess you
> shouldn't refresh the second patch.  I'm not sure how I would go about
> converting the xHCI driver to dynamic debugging, as I haven't looked
> into it.  Is there any documentation/simple examples?

Yes, just use 'dev_dbg' and you are finished.

Or pr_debug if you want to use different logging levels with your
macros.

> Greg, does the less-verbose patch with log levels still make sense if
> the driver got converted over to dynamic debugging?

I don't know what people really want to see.  In 6 months you will
probably only care about "debugging on or off" as the majority of the
messages only help you out when developing the driver, right?

So maybe par down some of the messages, or just live with seeing them
all, it will be easier in the end.

thanks,

grg k-h
