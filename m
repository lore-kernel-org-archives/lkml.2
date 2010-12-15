Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab0LODl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:41:57 -0500
Received: from kroah.org ([198.145.64.141]:48921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0LODl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:41:56 -0500
Date: Tue, 14 Dec 2010 19:42:43 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <srmt@cypress.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpmc timing configuration west bridge related
Message-ID: <20101215034243.GA2502@kroah.com>
References: <1292376787.3270.47.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292376787.3270.47.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 05:33:07PM -0800, Sutharsan wrote:
> Hi,
> 
> This patch adds gpmc configuration functions(./arch/arm/mach-omap2/usb-cywb-pnand.c) needed by cypress westbridge device controller driver.
> West bridge device controller driver is updated to use gpmc configuration functions instead of modifying gpmc registers directly.
> 
> Please let us know your comments.

Care to send it in a format which I can apply it in?  (hint, read
Documentation/SubmittingPatches please, specifically the section about
the Signed-off-by: mark)

thanks,

greg k-h
