Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1FFKSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:18:16 -0400
Received: from smtp.nokia.com ([147.243.128.24]:41898 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1FFKSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:18:15 -0400
Subject: Re: [PATCH 1/2] mtd: nuc900_nand: add missing nand_release in
 nuc900_nand_remove
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Wan ZongShun <mcuos.com@gmail.com>
In-Reply-To: <1307065913.10001.2.camel@phoenix>
References: <1307065913.10001.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 06 Jun 2011 13:13:47 +0300
Message-ID: <1307355227.3112.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 09:51 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/nand/nuc900_nand.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pushed both to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

