Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1BXJQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:16:47 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:35092 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504Ab1BXJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:16:44 -0500
Date: Thu, 24 Feb 2011 11:16:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Greg KH <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
Message-ID: <20110224091638.GH3528@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D64C81B.5060807@ahsoftware.de>
 <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org>
 <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
 <4D6621AB.10205@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6621AB.10205@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 24, 2011 at 10:15:23AM +0100, Alexander Holler wrote:
> >On Wed, Feb 23, 2011 at 10:26:20AM -0500, Alan Stern wrote:
> >>In both cases, it appears that the problem is caused by the fact that
> >>the musb host-controller driver doesn't set the hcd->has_tt flag.
> >>
> >>Felipe, you should know where it belongs.  It should be easy enough to
> >>add.
> >
> >Sure Alan, it's attached to this mail. Compile tested only though.
> >Michael, would you care to give your tested-by ?
> 
> I can do, I'm using exactly the same patch since yesterday. ;)
> 
> Tested-by: Alexander Holler <holler@ahsoftware.de>

Thanks a lot Alex, Greg, can you still take this to -rc ? Do you need a
pull request or you can take this one patch ?

-- 
balbi
