Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0ECAym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 20:54:42 -0400
Received: from mail.df.lth.se ([194.47.250.12]:61457 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752286Ab0ECAyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 20:54:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
Date: Mon,  3 May 2010 02:54:20 +0200
Message-Id: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set intended for Dan Williams tree includes:

- A fixed up COH 901 318 PrimeCell extension (unless applied
  to your tree already)
- Two DMA40 bug fixes.
- The latest iteration of the PrimeCell DMA extensions,
  altered and tested to work as Russell wants them. The PL011
  driver was tested:
  - on Versatile QEMU after I got it working again - OK
  - on U300 with DMA - OK
  - on U300 without DMA - OK
  - on U300 with fault injection, DMA always fail - OK
  - on U300 with fault injection, DMA fails every second time - OK
- Russell is this OK with you now?

Yours,
Linus Walleij
