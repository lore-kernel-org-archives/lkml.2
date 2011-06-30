Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1F3WJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:09:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35713 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/28] staging: ft1000-pcmcia: remove unused ft1000_asic_read and ft1000_asic_write functions
Date: Fri,  1 Jul 2011 00:03:51 +0200
Message-Id: <1309471437-12633-23-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions ft1000_asic_read() and ft1000_asic_write() are unused. Remove them.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |   34 ----------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index b3739b9..23854e0 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -88,40 +88,6 @@ MODULE_SUPPORTED_DEVICE("FT1000");
 
 //---------------------------------------------------------------------------
 //
-// Function:   ft1000_asic_read
-// Description: This function will retrieve the value of a specific ASIC
-//             register.
-// Input:
-//    dev - network device structure
-//    offset - ASIC register to read
-// Output:
-//    value - value of ASIC register
-//
-//---------------------------------------------------------------------------
-inline u16 ft1000_asic_read(struct net_device *dev, u16 offset)
-{
-	return (ft1000_read_reg(dev, offset));
-}
-
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_asic_write
-// Description: This function will set the value of a specific ASIC
-//             register.
-// Input:
-//    dev - network device structure
-//    value - value to set ASIC register
-// Output:
-//    none
-//
-//---------------------------------------------------------------------------
-inline void ft1000_asic_write(struct net_device *dev, u16 offset, u16 value)
-{
-	ft1000_write_reg(dev, offset, value);
-}
-
-//---------------------------------------------------------------------------
-//
 // Function:   ft1000_read_fifo_len
 // Description: This function will read the ASIC Uplink FIFO status register
 //             which will return the number of bytes remaining in the Uplink FIFO.
-- 
Ondrej Zary

