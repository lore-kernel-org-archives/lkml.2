Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2JQKNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:13:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61738 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2JQKNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:13:50 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 4/7] staging: csr: csr_wifi_sme_serialize.h: fixed over 80 char lines
Date: Wed, 17 Oct 2012 19:11:04 +0900
Message-Id: <1350468667-2406-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350468667-2406-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350468667-2406-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appropriately modified the lines over 80 characters.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_sme_serialize.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_sme_serialize.h b/drivers/staging/csr/csr_wifi_sme_serialize.h
index 75acefa..553bc16 100644
--- a/drivers/staging/csr/csr_wifi_sme_serialize.h
+++ b/drivers/staging/csr/csr_wifi_sme_serialize.h
@@ -477,7 +477,8 @@ extern void *CsrWifiSmePacketFilterSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePacketFilterSetCfmSizeof(void *msg);
 #define CsrWifiSmePacketFilterSetCfmSerFree CsrWifiSmePfree
 
-extern u8 *CsrWifiSmePermanentMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern u8 *CsrWifiSmePermanentMacAddressGetCfmSer(u8 *ptr, size_t *len,
+	void *msg);
 extern void *CsrWifiSmePermanentMacAddressGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePermanentMacAddressGetCfmSizeof(void *msg);
 #define CsrWifiSmePermanentMacAddressGetCfmSerFree CsrWifiSmePfree
@@ -502,7 +503,8 @@ extern size_t CsrWifiSmePowerConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmePowerConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmePowerConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8 *CsrWifiSmeRegulatoryDomainInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern u8 *CsrWifiSmeRegulatoryDomainInfoGetCfmSer(u8 *ptr, size_t *len,
+	void *msg);
 extern void *CsrWifiSmeRegulatoryDomainInfoGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRegulatoryDomainInfoGetCfmSizeof(void *msg);
 #define CsrWifiSmeRegulatoryDomainInfoGetCfmSerFree CsrWifiSmePfree
@@ -567,7 +569,8 @@ extern void *CsrWifiSmeSmeStaConfigSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeStaConfigSetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeStaConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8 *CsrWifiSmeStationMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern u8 *CsrWifiSmeStationMacAddressGetCfmSer(u8 *ptr, size_t *len,
+	void *msg);
 extern void *CsrWifiSmeStationMacAddressGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeStationMacAddressGetCfmSizeof(void *msg);
 #define CsrWifiSmeStationMacAddressGetCfmSerFree CsrWifiSmePfree
@@ -632,7 +635,8 @@ extern size_t CsrWifiSmeSmeCommonConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeCommonConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeSmeCommonConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8 *CsrWifiSmeInterfaceCapabilityGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern u8 *CsrWifiSmeInterfaceCapabilityGetCfmSer(u8 *ptr, size_t *len,
+	void *msg);
 extern void *CsrWifiSmeInterfaceCapabilityGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeInterfaceCapabilityGetCfmSizeof(void *msg);
 #define CsrWifiSmeInterfaceCapabilityGetCfmSerFree CsrWifiSmePfree
-- 
1.7.9.5

