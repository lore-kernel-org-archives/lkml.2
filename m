Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1FGQvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:51:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64740 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1FGQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:51:44 -0400
Date: Tue, 7 Jun 2011 10:51:40 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@au1.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the spi tree
Message-ID: <20110607165140.GA17754@ponder.secretlab.ca>
References: <20110607125359.604c2752.sfr@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125359.604c2752.sfr@au1.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:53:59PM +1000, Stephen Rothwell wrote:
> Hi Grant,
> 
> After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> make[3]: *** No rule to make target `drivers/spi/spi-dw-midpci.c', needed by `drivers/spi/spi-dw-midpci.o'.  Stop.
> 
> Caused by commit f8f82d4e7529 ("spi: reorganize drivers").
> 
> I have used the spi tree from next-20110606 for today.

Oops, missed one change.  Fixed now, thanks.

g.
