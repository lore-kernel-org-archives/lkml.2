Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab1FANcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:32:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39172 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab1FANc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:32:26 -0400
Subject: Re: [PATCH] ATMEL, AVR32: inline nand partition table access
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
References: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 01 Jun 2011 15:32:09 +0200
Message-ID: <1306935129.1097.3.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2011 13:32:11.0009 (UTC) FILETIME=[4F86DF10:01CC2060]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 17:49 +0400, Dmitry Eremin-Solenikov wrote:
> Currently atmel_nand driver used by AT91 and AVR32 calls a special callback
> which return nand partition table and number of partitions. However in all
> boards this callback returns just static data. So drop this callback and
> make atmel_nand use partition table provided statically via platform_data.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Thanks for this update, always nice seeing code being optimized. I
really can't recall why it was made like this in the first place...

For the AVR32 related parts:

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp diff>

Will this go through the linux-mtd tree (since it spans two archs) or
should it go through an arch tree?

-- 
Hans-Christian Egtvedt

