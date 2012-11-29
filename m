Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2K2FUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:20:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47938 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab2K2FUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:20:07 -0500
X-Sasl-enc: RIpwCxsh9t86nLK+PpixO9ir+ubTNu5ZOJbM3RhWv8aZ 1354166406
Date: Wed, 28 Nov 2012 21:21:45 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20121129052145.GS4375@kroah.com>
References: <20121129144302.f19a1984d498e0cebae8d5d0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129144302.f19a1984d498e0cebae8d5d0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:43:02PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/gpio/gpio-tps6586x.c between commit fe39f2f4dc84 ("mfd: Implement
> tps6586x gpio_to_irq") from the mfd tree and commit 3836309d9346 ("gpio:
> remove use of __devinit") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
