Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab0GZV20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:28:26 -0400
Received: from kroah.org ([198.145.64.141]:60627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0GZV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:28:25 -0400
Date: Mon, 26 Jul 2010 14:28:10 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCHv4 1/5] USB: gadget: composite: Better string override
 handling
Message-ID: <20100726212810.GA2247@kroah.com>
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 02:16:33PM +0200, Michal Nazarewicz wrote:
> Also, Greg, it's more complex then the previous version so I leave it
> up to you whether it'll get into the .35.  If you decide to include it
> for .36 rather then .35 consider adding the patches at the beginning
> as they won't apply at the end of the queue.

I've just queued up the last one for the .36 merge window, and I already
had 2 others in my tree for .36, so that's good.

I'll wait to get David's approval for your first patch before applying
it.

thanks,

greg k-h
