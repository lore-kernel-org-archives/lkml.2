Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1IJFWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 01:22:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35092 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1IJFWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 01:22:42 -0400
Date: Fri, 9 Sep 2011 22:22:07 -0700
From: Dan Carpenter <error27@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: Re: [PATCH 1/2] staging: et131x: Fix checkpatch whitespace warnings
Message-ID: <20110910052207.GA4807@mwanda>
References: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 12:49:06PM +0100, Mark Einon wrote:
> --- a/drivers/staging/et131x/et131x_netdev.c
> +++ b/drivers/staging/et131x/et131x_netdev.c
> @@ -408,7 +408,7 @@ void et131x_tx_timeout(struct net_device *netdev)
>  	unsigned long flags;
>  
>  	/* If the device is closed, ignore the timeout */
> -	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE));
> +	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE))
>  		return;
>  

You fixed a bug here.  That's not mentioned in the commit message.
Why would you want to keep that a secret?  Also it should go in a
separate commit.

But otherwise this patch looks good.

regards,
dan carpenter

