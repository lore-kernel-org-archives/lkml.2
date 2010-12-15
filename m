Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0LOWT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:19:26 -0500
Received: from kroah.org ([198.145.64.141]:33647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0LOWTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:19:24 -0500
Date: Wed, 15 Dec 2010 14:18:37 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <srmt@cypress.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
Message-ID: <20101215221837.GA12908@kroah.com>
References: <1292443046.1771.47.camel@sutharsan-laptop>
 <20101215201029.GA32710@kroah.com>
 <1292451075.1771.86.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292451075.1771.86.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Dec 15, 2010 at 02:11:15PM -0800, Sutharsan wrote:
> Hi Greg,
> 
> The driver is in staging area, the patch I submitted is required to get
> the driver out of staging area.

But you didn't say that, the patch you sent was not for the staging
tree, right?

> This patch is continuation of David Cross'(odc@cypress.com) earlier
> patch "[PATCH] gpmc, EXPORT_SYMBOLS, west bridge related".
> 
> I've modified the driver to use the function exported by "[PATCH] adding
> gpmc configuration functions, west bridge related". I'll submit the
> modified driver as another patch.

that would be good, thanks.

greg k-h
