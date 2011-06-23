Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab1FWCA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:00:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab1FWCAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rqvHt1ga/vXYBaB/bdQ3+HXsZB5rkMy8SpNc1tPdC94lhXYZej8CSYCY9rBKXbRjiL
         /CXqpLM9s8TDc9QmfKKfaJT7R1hHNE0kRunbONKkAqWMQIzjB8NKJcr+DMioG9cSVeMc
         VdCfbyXEM8P6gPyccl+1LeOiaJG3ZHV3A/ffQ=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 04/11] spi-dw: remove unused definition
Date: Wed, 22 Jun 2011 19:00:06 -0700
Message-Id: <1308794413-11069-5-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Remove unused #define

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 0148356..6a1ee63 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -47,9 +47,6 @@
 #define SPI_INT_RXFI			(1 << 4)
 #define SPI_INT_MSTI			(1 << 5)
 
-/* TX RX interrupt level threshold, max can be 256 */
-#define SPI_INT_THRESHOLD		32
-
 struct spi_dw_reg {
 	u32	ctrl0;
 	u32	ctrl1;
-- 
1.7.3.4

