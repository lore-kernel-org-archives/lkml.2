Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0LPStz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:49:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47115 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0LPStu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:49:50 -0500
Date: Thu, 16 Dec 2010 13:02:08 -0600
From: David Sin <davidsin@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/9] TI DMM-TILER driver
Message-ID: <20101216190207.GC6767@lba0869738>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
 <20101216172531.GG29435@lba0869738>
 <20101216173737.GA6767@lba0869738>
 <201012161843.48262.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012161843.48262.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 06:43:48PM +0100, Arnd Bergmann wrote:
> As far as I can tell, both DMM and GEM at a high level manage objects
> in video memory. The IOMMU that you have on the Omap hardware seems
> to resemble the GART that sits between PC-style video cards and main
> memory.
> 
> I don't know any details, but google quickly finds
> http://lwn.net/Articles/283798/ with a description of the
> initial GEM design. My main thought when looking over the
> DMM code was that this should not be tied too closely to a
> specific hardware, and GEM seems to be an existing abstraction
> that may fit what you need.
> 
> 	Arnd
Thanks for the pointer, Arnd.  I also found a nice readme file in 
the gpu/drm directory, which points to a wiki and source code.  
I'll read into this and get back to you.

BR,
-- 
David Sin
