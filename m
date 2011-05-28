Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1E1AZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:25:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48884 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab1E1AZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:25:28 -0400
X-Sasl-enc: V9ZT5UsJfDIFPkN1a5WhKl0Hk2pL2BFLpiSsJHPgLDCq 1306542326
Date: Sat, 28 May 2011 08:26:32 +0800
From: Greg KH <greg@kroah.com>
To: Arvid Brodin <arvid.brodin@enea.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Juergen Beisert <jbe@pengutronix.de>
Subject: Re: A standardized way of reporting kernel events to userspace
Message-ID: <20110528002632.GA19189@kroah.com>
References: <4DE02E11.5060007@enea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE02E11.5060007@enea.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 01:04:49AM +0200, Arvid Brodin wrote:
> Hi,
> 
> After I asked on linux-usb for a way for userspace to catch over-current events
> on the usb bus, it turned out that Juergen Beisert had had the need to do the
> exact same thing some time ago. He posted this patch using a uevent to notify
> userspace:

We've discussed why using uevents for this is not a good idea in the
past, and I don't think anything has changed since then.  You might want
to search the archives for details if you are curious.

As to other solutions, there's always netlink, and people have proposed,
seriously, to put dbus in the kernel to allow it to emit messages that
way.  I don't object to that, and I think there was even some patches
floating around to do that as well.  You might want to revive them and
see if that would fit your requirement here.

hope this helps,

greg k-h
