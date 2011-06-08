Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1FHO5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:57:03 -0400
Received: from smtp.nokia.com ([147.243.1.48]:28968 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1FHO5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:57:00 -0400
Subject: Re: [PATCH] mtd: davinci_nand: remove redundant
 mtd_device_unregister in nand_davinci_remove
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1307538097.17552.4.camel@phoenix>
References: <1307538097.17552.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 08 Jun 2011 17:52:37 +0300
Message-ID: <1307544757.31223.120.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 21:01 +0800, Axel Lin wrote:
> mtd_device_unregister is done in nand_release(),
> thus no need to call it in nand_davinci_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

