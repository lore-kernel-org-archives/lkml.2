Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2FKCsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:48:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2FKCr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:47:58 -0400
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 10:47:55 +0800
Message-ID: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
Subject: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: Ming Lei <ming.lei@canonical.com>
To: linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Balaji T K <balajitk@ti.com>,
        Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After bisecting, I found that the commit below can ruin the mmc card data
(writing incorrect file, or fs is corrupt) on my beagle-xm revB, and reverting
the commit below will fix the problem.


commit dba3c29ea4a1d5d544f59b94fd8a41662135e071
Author: Balaji T K <balajitk@ti.com>
Date:   Mon Apr 9 12:08:32 2012 +0530

    mmc: omap_hsmmc: Enable Auto CMD12

    Enable Auto-CMD12 for multi block read/write on HSMMC.
    Tested on OMAP4430, OMAP3430 and OMAP2430 SDP


Thanks,
--
Ming Lei
