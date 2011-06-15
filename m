Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1FORXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:23:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62671 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1FORXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vl+mqeFyGT9qcSaKDhmIqC3apGhSgxGMPSjkzZJ+BYUsIg7vZ2neEdEJuS3IsonmAO
         In3IQ0z+BUh4FCeHFW1c5Gl230VLinSPo70WcNVuT+A+FATZdS9quYiqXZOJSdV82YN5
         8b0BjeZYSPb8I8BrUwMjx/xYOvjZEjhL4Mkqc=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 1/5] spi/makefile:  Fix typo from reorganize drivers patch.
Date: Wed, 15 Jun 2011 10:23:04 -0700
Message-Id: <1308158588-17249-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Fix Makefile to build designware driver.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index f6d5018..b60b04b 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_SPI_DAVINCI)		+= spi-davinci.o
 obj-$(CONFIG_SPI_DESIGNWARE)		+= spi-dw.o
 obj-$(CONFIG_SPI_DW_MMIO)		+= spi-dw-mmio.o
 obj-$(CONFIG_SPI_DW_PCI)		+= spi-dw-midpci.o
-spi_dw_midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
+spi-dw-midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
 obj-$(CONFIG_SPI_EP93XX)		+= spi-ep93xx.o
 obj-$(CONFIG_SPI_FSL_LIB)		+= spi-fsl-lib.o
 obj-$(CONFIG_SPI_FSL_ESPI)		+= spi-fsl-espi.o
-- 
1.7.3.4

