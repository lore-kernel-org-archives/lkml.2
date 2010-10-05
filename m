Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0JETLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:11:20 -0400
Received: from kroah.org ([198.145.64.141]:39000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0JETLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:11:17 -0400
Date: Tue, 5 Oct 2010 12:07:41 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 0/2] omap: dsp: make the driver actually work
Message-ID: <20101005190741.GC20825@kroah.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 07:09:13PM +0300, Felipe Contreras wrote:
> Hi,
> 
> It seems the platform device was dropped from the migration of tidspbridge into
> staging, plus the sdram meblock (previously bootmem) required for it work are
> gone.
> 
> Withouth these patches the driver loads, but doesn't do anything.
> 
> A second issue with ioremap() still remains, but that can be solved by
> reverting 309caa9.
> 
> I think these might be worth to get into 2.6.36, if not, I have versions with
> more changes; cleanups and so on.

I've applied this to my staging-next tree, for .37, as it's not a big
deal for .36.

thanks,

greg k-h
