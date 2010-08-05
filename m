Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab0HELZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:25:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18707 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab0HELZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:25:21 -0400
Subject: Re: [PATCH] atmel_nand: Fix warning: 'part_probes' defined but not
 used
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andreas =?ISO-8859-1?Q?Bie=DFmann?= <biessmann@corscience.de>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Sandeep Paulraj <s-paulraj@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1281004721-397-1-git-send-email-biessmann@corscience.de>
References: <1279099026-24298-1-git-send-email-biessmann@corscience.de>
	 <1281004721-397-1-git-send-email-biessmann@corscience.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 13:50:40 +0300
Message-ID: <1281005440.15689.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Aug 2010 10:52:03.0352 (UTC) FILETIME=[3CFDC180:01CB348C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 12:38 +0200, Andreas Bießmann wrote:
> This patch fixes
> 
> drivers/mtd/nand/atmel_nand.c:372: warning: 'part_probes' defined but not used
> 
> which is issued when CONFIG_MTD_PARTITIONS is defined but
> CONFIG_MTD_CMDLINE_PARTS not.
> 
> Signed-off-by: Andreas Bießmann <biessmann@corscience.de>

Pushed to my l2-mtd-2.6.git / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

