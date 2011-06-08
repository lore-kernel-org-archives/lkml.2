Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1FHLNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 07:13:37 -0400
Received: from smtp.nokia.com ([147.243.1.48]:46761 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1FHLNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 07:13:36 -0400
Subject: Re: [PATCH] mtd: ndfc: fix a memory leak in ndfc_remove
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org,
        Sean MacLennan <smaclennan@pikatech.com>
In-Reply-To: <1307458521.22584.1.camel@phoenix>
References: <1307458521.22584.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 08 Jun 2011 14:08:55 +0300
Message-ID: <1307531335.31223.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:55 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mtd/nand/ndfc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

