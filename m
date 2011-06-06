Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FFKYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:24:39 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50448 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1FFKYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:24:36 -0400
Subject: Re: [PATCH] mtd: pxa3xx_nand: remove unused variable 'mtd'
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1307086473.7474.1.camel@phoenix>
References: <1307086473.7474.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 06 Jun 2011 13:20:11 +0300
Message-ID: <1307355611.3112.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 15:34 +0800, Axel Lin wrote:
> Remove unused variable 'mtd' to eliminate below warning.
> 
>   CC      drivers/mtd/nand/pxa3xx_nand.o
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_suspend':
> drivers/mtd/nand/pxa3xx_nand.c:1167: warning: unused variable 'mtd'
> drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_resume':
> drivers/mtd/nand/pxa3xx_nand.c:1180: warning: unused variable 'mtd'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

