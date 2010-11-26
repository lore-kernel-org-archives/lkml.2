Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0KZPqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:46:22 -0500
Received: from smtp.nokia.com ([147.243.1.47]:35915 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0KZPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:46:21 -0500
Subject: Re: [PATCH] MTD: NAND: jz4740: Make 'struct platform_driver
 jz_nand_driver' static
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289498568-12191-1-git-send-email-lars@metafoo.de>
References: <1289498568-12191-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 26 Nov 2010 17:45:30 +0200
Message-ID: <1290786330.2552.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 19:02 +0100, Lars-Peter Clausen wrote:
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/mtd/nand/jz4740_nand.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Pushed both patches to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

