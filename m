Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1BUGcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:32:03 -0500
Received: from kroah.org ([198.145.64.141]:33565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1BUGbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:31:48 -0500
Date: Sun, 20 Feb 2011 22:32:28 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, Ilya Yanok <yanok@emcraft.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the driver-core tree
Message-ID: <20110221063228.GB30091@kroah.com>
References: <20110221170226.c43175f7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221170226.c43175f7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 05:02:26PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/net/dnet.c: In function 'dnet_mii_init':
> drivers/net/dnet.c:340: warning: passing argument 1 of 'platform_set_drvdata' from incompatible pointer type
> include/linux/platform_device.h:138: note: expected 'struct platform_device *' but argument is of type 'struct net_device *'
> 
> Revealed by commit 71d642908d4e8e7a2a4a6e0490432e719ff466d5 ("Driver
> core: convert platform_{get,set}_drvdata to static inline functions").
> Introduced by commit 4796417417a62e2ae83d92cb92e1ecf9ec67b5f5 ("dnet:
> Dave DNET ethernet controller driver (updated)").

It sounds like the driver is wrong here :(

thanks,

greg k-h
