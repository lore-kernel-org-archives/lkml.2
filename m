Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0GHNX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:23:57 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38922 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab0GHNX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:23:56 -0400
Subject: Re: [PATCH v2 17/26] MTD: Nand: Add JZ4740 NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <4C35D084.7050605@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	 <1276924111-11158-18-git-send-email-lars@metafoo.de>
	 <1278569214.12733.38.camel@localhost>  <4C35D084.7050605@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 16:19:02 +0300
Message-ID: <1278595142.20321.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2010 13:22:58.0219 (UTC) FILETIME=[AE8BCFB0:01CB1EA0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 15:20 +0200, Lars-Peter Clausen wrote:
> On the other hand I'm wondering where on would put headers for non platform specific
> drivers?

If we are talking about MTD, then drivers/mtd ?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

