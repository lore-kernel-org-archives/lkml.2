Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab0JRUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:24:54 -0400
Received: from void.printf.net ([89.145.121.20]:49980 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0JRUYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:24:52 -0400
Date: Mon, 18 Oct 2010 21:24:43 +0100
From: Chris Ball <cjb@laptop.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-mmc@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (mmc
	tree related)
Message-ID: <20101018202443.GA4503@void.printf.net>
References: <20101018183540.2a7dfc8f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018183540.2a7dfc8f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Oct 18, 2010 at 06:35:40PM +1100, Stephen Rothwell wrote:
> After merging the scsi-post-merge tree, today's linux-next build ()
> failed like this:
[...] 
> Caused by commit a2fe088a5aaa51b54c018cf309cdc728d5f4e540 ("mmc:
> sdhci-of-esdhc: factor out common stuff").
> 
> This was clearly never build tested ...
> 
> I have reverted that commit for today.

Sorry about this -- you're right, my test compile missed this patch.
I've pushed a tested fix now.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
