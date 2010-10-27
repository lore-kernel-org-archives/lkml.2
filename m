Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0J0SAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:00:01 -0400
Received: from asmtpout024.mac.com ([17.148.16.99]:60625 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0J0R76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:59:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-27_08:2010-10-27,2010-10-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010270089
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: wl12xx board_ref_clock
Date: Wed, 27 Oct 2010 21:59:44 +0400
Message-id: <1C13481E-69E7-4779-B472-42DD49619A89@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,
	          To which device does board_ref_clock refer to? On my board, the SDIO CLK line from the MMC2 controller is connected to the LSR TiWi wlan module. 
                  
@@ -164,12 +169,25 @@ static void __init beagle_display_init(void)
 
 #include "sdram-micron-mt46h32m32lf-6.h"
 
+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
+	.board_ref_clock = 2, /* 38.4 MHz */
+};

What is the impact of not specifying a board_ref_clock?

Best regards,

Elvis Dowson

