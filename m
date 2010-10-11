Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0JKKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:09:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JKKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:09:25 -0400
From: Bernhard Walle <walle@corscience.de>
To: ddaney@caviumnetworks.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: octeon: Add Lanai board USB clock type
Date: Mon, 11 Oct 2010 12:09:07 +0200
Message-Id: <1286791747-3151-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:t+fiQ64dmRUDsPA9cFPaS4FvJpSzqp9UVOGnANMyRGo
 iHTG0MMqbXpCOv69eXMVSwMa3ZepwNIol2vVpA5DlJodvRxPND
 ZQ7RdO4M0oEVGa7qFqsRO+Sfq/0Yh5gLTiDUesj45IOfHeVC7E
 EbTvd+s1iTiaWrEcAWr6Nrc8ioROoFV8SSnYG5EErylNeBGwgw
 jhA0uRFDEGNOTm2BwRG/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/staging/octeon/cvmx-helper-board.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/octeon/cvmx-helper-board.c b/drivers/staging/octeon/cvmx-helper-board.c
index 5793318..f8ae6b4 100644
--- a/drivers/staging/octeon/cvmx-helper-board.c
+++ b/drivers/staging/octeon/cvmx-helper-board.c
@@ -752,6 +752,7 @@ cvmx_helper_board_usb_clock_types_t __cvmx_helper_board_usb_get_clock_type(void)
 {
 	switch (cvmx_sysinfo_get()->board_type) {
 	case CVMX_BOARD_TYPE_BBGW_REF:
+	case CVMX_BOARD_TYPE_LANAI2_G:
 		return USB_CLOCK_TYPE_CRYSTAL_12;
 	}
 	return USB_CLOCK_TYPE_REF_48;
-- 
1.7.1

