Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0FMJnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 05:43:12 -0400
Received: from smtp.nokia.com ([192.100.122.230]:57865 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0FMJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 05:43:09 -0400
Subject: Re: [RFC][PATCH 17/26] MTD: Nand: Add JZ4740 NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1275505950-17334-1-git-send-email-lars@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
	 <1275505950-17334-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 12:40:15 +0300
Message-ID: <1276422015.19028.204.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Jun 2010 09:42:42.0693 (UTC) FILETIME=[C526D350:01CB0ADC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 21:12 +0200, Lars-Peter Clausen wrote:
> This patch adds support for the NAND controller on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/nand/Kconfig        |    6 +
>  drivers/mtd/nand/Makefile       |    1 +
>  drivers/mtd/nand/jz4740_nand.c  |  442 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mtd/jz4740_nand.h |   34 +++
>  4 files changed, 483 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mtd/nand/jz4740_nand.c
>  create mode 100644 include/linux/mtd/jz4740_nand.h

I doubt "include/linux/" is the right place to define 'struct
jz_nand_platform_data' - it should instead live is somwhere in
arch/mips/

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

