Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0EROIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:08:32 -0400
Received: from kroah.org ([198.145.64.141]:46555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab0EROI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:08:27 -0400
Date: Tue, 18 May 2010 07:08:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20100518140806.GA24463@kroah.com>
References: <20100518174253.37e38d66.sfr@canb.auug.org.au>
 <Pine.LNX.4.44L0.1005180949560.1795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005180949560.1795-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 09:54:45AM -0400, Alan Stern wrote:
> On Tue, 18 May 2010, Stephen Rothwell wrote:
> 
> > Hi Greg,
> > 
> > After merging the usb tree, today's linux-next build (powerpc
> > ppc6xx_defconfig) failed like this:
> > 
> > drivers/usb/host/ehci-fsl.c:316: error: 'ehci' undeclared (first use in this function)
> > 
> > Caused by commit d19f8cd047971b43844d61d995be736dacb4826a ("USB: EHCI:
> > fix controller wakeup flag settings during suspend").
> 
> Here's a fix for the problem.  It's awfully easy to mess things up when 
> changing code for architectures you don't have.
> 
> Greg, can you merge this in with the original patch?

Will do, thanks for the patch.

greg k-h
