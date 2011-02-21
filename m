Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1BUVFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:05:20 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:55901 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1BUVFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:05:18 -0500
X-Greylist: delayed 2798 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 16:05:18 EST
Message-ID: <4D62C897.5020707@emcraft.com>
Date: Mon, 21 Feb 2011 23:18:31 +0300
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the driver-core tree
References: <20110221170226.c43175f7.sfr@canb.auug.org.au>
In-Reply-To: <20110221170226.c43175f7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Greg,

On 21.02.2011 09:02, Stephen Rothwell wrote:
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> drivers/net/dnet.c: In function 'dnet_mii_init':
> drivers/net/dnet.c:340: warning: passing argument 1 of 'platform_set_drvdata' from incompatible pointer type
> include/linux/platform_device.h:138: note: expected 'struct platform_device *' but argument is of type 'struct net_device *'

It's actually a bug in the driver. Thanks for reporting. I'll send the 
patch as a follow up.

Regards, Ilya.
