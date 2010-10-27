Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0J0Sn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:43:28 -0400
Received: from asmtpout025.mac.com ([17.148.16.100]:33370 "EHLO
	asmtpout025.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0J0Sn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:43:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010270096
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-27_09:2010-10-27,2010-10-27,1970-01-01 signatures=0
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: sdio ids for wl12xx
Date: Wed, 27 Oct 2010 22:42:48 +0400
Message-id: <5B495C0D-66BE-4A48-ADC0-6F8C74FF70D9@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,
                  I was wondering, don't you need the sdio_ids for TI WL12xx as follows? Do you think the LSR TiWi SDIO ids would be different? 

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 33b2ea0..66f9e3e 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -43,4 +43,7 @@
 #define SDIO_DEVICE_ID_SIANO_NOVA_A0		0x1100
 #define SDIO_DEVICE_ID_SIANO_STELLAR 		0x5347
 
+#define SDIO_VENDOR_ID_TI				0x104c
+#define SDIO_DEVICE_ID_TI_WL12xx		0x9066
+
 #endif

Best regards,

Elvis Dowson

