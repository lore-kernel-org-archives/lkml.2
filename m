Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330Ab0KQVV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:21:59 -0500
Received: from kroah.org ([198.145.64.141]:58761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935242Ab0KQVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:21:58 -0500
Date: Wed, 17 Nov 2010 13:18:52 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sst: remove rest of aava bits and aava related code
Message-ID: <20101117211852.GC31776@kroah.com>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:57:57PM +0000, Alan Cox wrote:
> From: Vinod Koul <vinod.koul@intel.com>
> 
> This removes the remaining bit of aava dependent and related bits from driver
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

I edited this one by hand to get it to apply, but the other 7 were
harder.  Can you redo them and resend them as the pr_debug() changes
that are now in staging-next are massivly conflicting with this series.

thanks,

greg k-h
