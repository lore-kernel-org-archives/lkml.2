Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1FGCyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 22:54:06 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57888 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1FGCyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 22:54:04 -0400
Date: Tue, 7 Jun 2011 12:53:59 +1000
From: Stephen Rothwell <sfr@au1.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20110607125359.604c2752.sfr@au1.ibm.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

make[3]: *** No rule to make target `drivers/spi/spi-dw-midpci.c', needed by `drivers/spi/spi-dw-midpci.o'.  Stop.

Caused by commit f8f82d4e7529 ("spi: reorganize drivers").

I have used the spi tree from next-20110606 for today.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
