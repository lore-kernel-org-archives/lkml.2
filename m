Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1IVNxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:53:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43347 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751610Ab1IVNxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:53:54 -0400
Date: Thu, 22 Sep 2011 14:53:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Samsung GPIO changes break boot on Cragganmore
Message-ID: <20110922135351.GC5173@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Something in the recent GPIO changes have broken the boot for me on
Cragganmore (S3C6410 based) systems.  The boot dies before any console
output is produced so it's hard to isolate exactly what went wrong but
backing out:

   5ec7414 ARM: SAMSUNG: Remove useless Samsung GPIO related CONFIGs
   7c15788 ARM: SAMSUNG: Update the name of regarding Samsung GPIO
   bedcda6 gpio/samsung: gpio-samsung.c to support Samsung GPIOs

fixes the system boot for me.  The diff is rather substantial so it's
hard to check by eyeball unfortunately.

Thanks,
Mark
