Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0LOX3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:29:13 -0500
Received: from kroah.org ([198.145.64.141]:46660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab0LOX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:29:10 -0500
Date: Wed, 15 Dec 2010 15:22:11 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <srmt@cypress.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] west bridge device driver changes to use gpmc
 configuration functions
Message-ID: <20101215232211.GA27844@kroah.com>
References: <1292454225.1771.184.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292454225.1771.184.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 03:03:45PM -0800, Sutharsan wrote:
> 
> This patch contains changes to west bridge device controller driver in staging area.
> The west bridge device controller driver is modified to use gpmc configuration functions instead of directly modifying gpmc registers.
> This patch is continuation of David Cross' <david.cross@cypress.com> earlier patch "[PATCH] gpmc, EXPORT_SYMBOLS, west bridge related"

Please line-wrap your changelog entries to be sane.

> This patch depends on "[PATCH] adding gpmc configuration functions, west bridge related".

I no longer have this patch in my queue, sorry.

And, as it's only for a staging driver, shouldn't that patch be in the
staging/westbridge/ subdirectory as well?  Otherwise you need to get it
approved by the proper arm subsystem maintainer.

> Thanks,
> Sutharsan.

Don't put this within a changelog entry.

Ideally I should be able to take your email, edit nothing, and apply it
as-is.  This one would require a lot of editing :(

Care to redo it, and resend the other one?

thanks,

greg k-h
