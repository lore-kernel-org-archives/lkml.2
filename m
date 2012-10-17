Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2JQKNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:13:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2JQKNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:13:47 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/7] staging: csr: csr_wifi_sme_serialize.h: Fixed from foo* bar to foo *bar
Date: Wed, 17 Oct 2012 19:11:03 +0900
Message-Id: <1350468667-2406-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350468667-2406-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350468667-2406-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the coding style convention warnings for the statements of the
pointer variable declaration.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_sme_serialize.h |  316 +++++++++++++-------------
 1 file changed, 158 insertions(+), 158 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_sme_serialize.h b/drivers/staging/csr/csr_wifi_sme_serialize.h
index bfc180b..75acefa 100644
--- a/drivers/staging/csr/csr_wifi_sme_serialize.h
+++ b/drivers/staging/csr/csr_wifi_sme_serialize.h
@@ -32,13 +32,13 @@ extern void CsrWifiSmePfree(void *ptr);
 #define CsrWifiSmeAdhocConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeAdhocConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeAdhocConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeAdhocConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeAdhocConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeAdhocConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeAdhocConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeAdhocConfigSetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeBlacklistReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeBlacklistReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeBlacklistReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeBlacklistReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeBlacklistReqSizeof(void *msg);
 extern void CsrWifiSmeBlacklistReqSerFree(void *msg);
 
@@ -47,8 +47,8 @@ extern void CsrWifiSmeBlacklistReqSerFree(void *msg);
 #define CsrWifiSmeCalibrationDataGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeCalibrationDataGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCalibrationDataSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCalibrationDataSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCalibrationDataSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCalibrationDataSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCalibrationDataSetReqSizeof(void *msg);
 extern void CsrWifiSmeCalibrationDataSetReqSerFree(void *msg);
 
@@ -57,8 +57,8 @@ extern void CsrWifiSmeCalibrationDataSetReqSerFree(void *msg);
 #define CsrWifiSmeCcxConfigGetReqSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeCcxConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCcxConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCcxConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCcxConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCcxConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCcxConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeCcxConfigSetReqSerFree CsrWifiSmePfree
 
@@ -67,8 +67,8 @@ extern size_t CsrWifiSmeCcxConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeCoexConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeCoexConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCoexConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCoexConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCoexConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCoexConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCoexConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeCoexConfigSetReqSerFree CsrWifiSmePfree
 
@@ -77,8 +77,8 @@ extern size_t CsrWifiSmeCoexConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeCoexInfoGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeCoexInfoGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeConnectReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectReqSizeof(void *msg);
 extern void CsrWifiSmeConnectReqSerFree(void *msg);
 
@@ -117,13 +117,13 @@ extern void CsrWifiSmeConnectReqSerFree(void *msg);
 #define CsrWifiSmeHostConfigGetReqSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeHostConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeHostConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeHostConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeHostConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeHostConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeHostConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeHostConfigSetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeKeyReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeKeyReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeKeyReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeKeyReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeKeyReqSizeof(void *msg);
 #define CsrWifiSmeKeyReqSerFree CsrWifiSmePfree
 
@@ -137,33 +137,33 @@ extern size_t CsrWifiSmeKeyReqSizeof(void *msg);
 #define CsrWifiSmeMibConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeMibConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMibConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeMibConfigSetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMibGetNextReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibGetNextReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibGetNextReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibGetNextReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibGetNextReqSizeof(void *msg);
 extern void CsrWifiSmeMibGetNextReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeMibGetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibGetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibGetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibGetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibGetReqSizeof(void *msg);
 extern void CsrWifiSmeMibGetReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeMibSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibSetReqSizeof(void *msg);
 extern void CsrWifiSmeMibSetReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeMulticastAddressReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMulticastAddressReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMulticastAddressReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMulticastAddressReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMulticastAddressReqSizeof(void *msg);
 extern void CsrWifiSmeMulticastAddressReqSerFree(void *msg);
 
-extern u8* CsrWifiSmePacketFilterSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePacketFilterSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePacketFilterSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePacketFilterSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePacketFilterSetReqSizeof(void *msg);
 extern void CsrWifiSmePacketFilterSetReqSerFree(void *msg);
 
@@ -172,8 +172,8 @@ extern void CsrWifiSmePacketFilterSetReqSerFree(void *msg);
 #define CsrWifiSmePermanentMacAddressGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmePermanentMacAddressGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmePmkidReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePmkidReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePmkidReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePmkidReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePmkidReqSizeof(void *msg);
 extern void CsrWifiSmePmkidReqSerFree(void *msg);
 
@@ -182,8 +182,8 @@ extern void CsrWifiSmePmkidReqSerFree(void *msg);
 #define CsrWifiSmePowerConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmePowerConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmePowerConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePowerConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePowerConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePowerConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePowerConfigSetReqSizeof(void *msg);
 #define CsrWifiSmePowerConfigSetReqSerFree CsrWifiSmePfree
 
@@ -197,8 +197,8 @@ extern size_t CsrWifiSmePowerConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeRoamingConfigGetReqSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeRoamingConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRoamingConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRoamingConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRoamingConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRoamingConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRoamingConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeRoamingConfigSetReqSerFree CsrWifiSmePfree
 
@@ -207,13 +207,13 @@ extern size_t CsrWifiSmeRoamingConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeScanConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeScanConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeScanConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeScanConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeScanConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeScanConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeScanConfigSetReqSizeof(void *msg);
 extern void CsrWifiSmeScanConfigSetReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeScanFullReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeScanFullReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeScanFullReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeScanFullReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeScanFullReqSizeof(void *msg);
 extern void CsrWifiSmeScanFullReqSerFree(void *msg);
 
@@ -232,8 +232,8 @@ extern void CsrWifiSmeScanFullReqSerFree(void *msg);
 #define CsrWifiSmeSmeStaConfigGetReqSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeSmeStaConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeSmeStaConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSmeStaConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSmeStaConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSmeStaConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeStaConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeSmeStaConfigSetReqSerFree CsrWifiSmePfree
 
@@ -242,8 +242,8 @@ extern size_t CsrWifiSmeSmeStaConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeStationMacAddressGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeStationMacAddressGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeTspecReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeTspecReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeTspecReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeTspecReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeTspecReqSizeof(void *msg);
 extern void CsrWifiSmeTspecReqSerFree(void *msg);
 
@@ -252,8 +252,8 @@ extern void CsrWifiSmeTspecReqSerFree(void *msg);
 #define CsrWifiSmeVersionsGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeVersionsGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeWifiFlightmodeReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeWifiFlightmodeReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeWifiFlightmodeReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeWifiFlightmodeReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeWifiFlightmodeReqSizeof(void *msg);
 extern void CsrWifiSmeWifiFlightmodeReqSerFree(void *msg);
 
@@ -262,13 +262,13 @@ extern void CsrWifiSmeWifiFlightmodeReqSerFree(void *msg);
 #define CsrWifiSmeWifiOffReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeWifiOffReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeWifiOnReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeWifiOnReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeWifiOnReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeWifiOnReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeWifiOnReqSizeof(void *msg);
 extern void CsrWifiSmeWifiOnReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeCloakedSsidsSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCloakedSsidsSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCloakedSsidsSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCloakedSsidsSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCloakedSsidsSetReqSizeof(void *msg);
 extern void CsrWifiSmeCloakedSsidsSetReqSerFree(void *msg);
 
@@ -282,8 +282,8 @@ extern void CsrWifiSmeCloakedSsidsSetReqSerFree(void *msg);
 #define CsrWifiSmeSmeCommonConfigGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeSmeCommonConfigGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeSmeCommonConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSmeCommonConfigSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSmeCommonConfigSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSmeCommonConfigSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeCommonConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeSmeCommonConfigSetReqSerFree CsrWifiSmePfree
 
@@ -292,13 +292,13 @@ extern size_t CsrWifiSmeSmeCommonConfigSetReqSizeof(void *msg);
 #define CsrWifiSmeInterfaceCapabilityGetReqSizeof CsrWifiEventSizeof
 #define CsrWifiSmeInterfaceCapabilityGetReqSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeWpsConfigurationReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeWpsConfigurationReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeWpsConfigurationReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeWpsConfigurationReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeWpsConfigurationReqSizeof(void *msg);
 extern void CsrWifiSmeWpsConfigurationReqSerFree(void *msg);
 
-extern u8* CsrWifiSmeSetReqSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSetReqDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSetReqSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSetReqDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSetReqSizeof(void *msg);
 extern void CsrWifiSmeSetReqSerFree(void *msg);
 
@@ -307,8 +307,8 @@ extern void CsrWifiSmeSetReqSerFree(void *msg);
 #define CsrWifiSmeActivateCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeActivateCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeAdhocConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeAdhocConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeAdhocConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeAdhocConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeAdhocConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeAdhocConfigGetCfmSerFree CsrWifiSmePfree
 
@@ -317,23 +317,23 @@ extern size_t CsrWifiSmeAdhocConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeAdhocConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeAdhocConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeAssociationCompleteIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeAssociationCompleteIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeAssociationCompleteIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeAssociationCompleteIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeAssociationCompleteIndSizeof(void *msg);
 extern void CsrWifiSmeAssociationCompleteIndSerFree(void *msg);
 
-extern u8* CsrWifiSmeAssociationStartIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeAssociationStartIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeAssociationStartIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeAssociationStartIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeAssociationStartIndSizeof(void *msg);
 #define CsrWifiSmeAssociationStartIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeBlacklistCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeBlacklistCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeBlacklistCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeBlacklistCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeBlacklistCfmSizeof(void *msg);
 extern void CsrWifiSmeBlacklistCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeCalibrationDataGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCalibrationDataGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCalibrationDataGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCalibrationDataGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCalibrationDataGetCfmSizeof(void *msg);
 extern void CsrWifiSmeCalibrationDataGetCfmSerFree(void *msg);
 
@@ -342,18 +342,18 @@ extern void CsrWifiSmeCalibrationDataGetCfmSerFree(void *msg);
 #define CsrWifiSmeCalibrationDataSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeCalibrationDataSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCcxConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCcxConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCcxConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCcxConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCcxConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeCcxConfigGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCcxConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCcxConfigSetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCcxConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCcxConfigSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCcxConfigSetCfmSizeof(void *msg);
 #define CsrWifiSmeCcxConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCoexConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCoexConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCoexConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCoexConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCoexConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeCoexConfigGetCfmSerFree CsrWifiSmePfree
 
@@ -362,33 +362,33 @@ extern size_t CsrWifiSmeCoexConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeCoexConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeCoexConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCoexInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCoexInfoGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCoexInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCoexInfoGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCoexInfoGetCfmSizeof(void *msg);
 #define CsrWifiSmeCoexInfoGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeConnectCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectCfmSizeof(void *msg);
 #define CsrWifiSmeConnectCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeConnectionConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectionConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectionConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectionConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectionConfigGetCfmSizeof(void *msg);
 extern void CsrWifiSmeConnectionConfigGetCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeConnectionInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectionInfoGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectionInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectionInfoGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectionInfoGetCfmSizeof(void *msg);
 extern void CsrWifiSmeConnectionInfoGetCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeConnectionQualityIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectionQualityIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectionQualityIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectionQualityIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectionQualityIndSizeof(void *msg);
 #define CsrWifiSmeConnectionQualityIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeConnectionStatsGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeConnectionStatsGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeConnectionStatsGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeConnectionStatsGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeConnectionStatsGetCfmSizeof(void *msg);
 #define CsrWifiSmeConnectionStatsGetCfmSerFree CsrWifiSmePfree
 
@@ -397,8 +397,8 @@ extern size_t CsrWifiSmeConnectionStatsGetCfmSizeof(void *msg);
 #define CsrWifiSmeDeactivateCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeDeactivateCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeDisconnectCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeDisconnectCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeDisconnectCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeDisconnectCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeDisconnectCfmSizeof(void *msg);
 #define CsrWifiSmeDisconnectCfmSerFree CsrWifiSmePfree
 
@@ -407,38 +407,38 @@ extern size_t CsrWifiSmeDisconnectCfmSizeof(void *msg);
 #define CsrWifiSmeEventMaskSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeEventMaskSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeHostConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeHostConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeHostConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeHostConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeHostConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeHostConfigGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeHostConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeHostConfigSetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeHostConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeHostConfigSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeHostConfigSetCfmSizeof(void *msg);
 #define CsrWifiSmeHostConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeIbssStationIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeIbssStationIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeIbssStationIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeIbssStationIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeIbssStationIndSizeof(void *msg);
 #define CsrWifiSmeIbssStationIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeKeyCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeKeyCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeKeyCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeKeyCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeKeyCfmSizeof(void *msg);
 #define CsrWifiSmeKeyCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeLinkQualityGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeLinkQualityGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeLinkQualityGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeLinkQualityGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeLinkQualityGetCfmSizeof(void *msg);
 #define CsrWifiSmeLinkQualityGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMediaStatusIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMediaStatusIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMediaStatusIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMediaStatusIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMediaStatusIndSizeof(void *msg);
 extern void CsrWifiSmeMediaStatusIndSerFree(void *msg);
 
-extern u8* CsrWifiSmeMibConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeMibConfigGetCfmSerFree CsrWifiSmePfree
 
@@ -447,13 +447,13 @@ extern size_t CsrWifiSmeMibConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeMibConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeMibConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMibGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibGetCfmSizeof(void *msg);
 extern void CsrWifiSmeMibGetCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeMibGetNextCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMibGetNextCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMibGetNextCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMibGetNextCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMibGetNextCfmSizeof(void *msg);
 extern void CsrWifiSmeMibGetNextCfmSerFree(void *msg);
 
@@ -462,38 +462,38 @@ extern void CsrWifiSmeMibGetNextCfmSerFree(void *msg);
 #define CsrWifiSmeMibSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeMibSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMicFailureIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMicFailureIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMicFailureIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMicFailureIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMicFailureIndSizeof(void *msg);
 #define CsrWifiSmeMicFailureIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeMulticastAddressCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeMulticastAddressCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeMulticastAddressCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeMulticastAddressCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeMulticastAddressCfmSizeof(void *msg);
 extern void CsrWifiSmeMulticastAddressCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmePacketFilterSetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePacketFilterSetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePacketFilterSetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePacketFilterSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePacketFilterSetCfmSizeof(void *msg);
 #define CsrWifiSmePacketFilterSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmePermanentMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePermanentMacAddressGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePermanentMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePermanentMacAddressGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePermanentMacAddressGetCfmSizeof(void *msg);
 #define CsrWifiSmePermanentMacAddressGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmePmkidCandidateListIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePmkidCandidateListIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePmkidCandidateListIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePmkidCandidateListIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePmkidCandidateListIndSizeof(void *msg);
 extern void CsrWifiSmePmkidCandidateListIndSerFree(void *msg);
 
-extern u8* CsrWifiSmePmkidCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePmkidCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePmkidCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePmkidCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePmkidCfmSizeof(void *msg);
 extern void CsrWifiSmePmkidCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmePowerConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmePowerConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmePowerConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmePowerConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmePowerConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmePowerConfigGetCfmSerFree CsrWifiSmePfree
 
@@ -502,33 +502,33 @@ extern size_t CsrWifiSmePowerConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmePowerConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmePowerConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRegulatoryDomainInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRegulatoryDomainInfoGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRegulatoryDomainInfoGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRegulatoryDomainInfoGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRegulatoryDomainInfoGetCfmSizeof(void *msg);
 #define CsrWifiSmeRegulatoryDomainInfoGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRoamCompleteIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRoamCompleteIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRoamCompleteIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRoamCompleteIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRoamCompleteIndSizeof(void *msg);
 #define CsrWifiSmeRoamCompleteIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRoamStartIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRoamStartIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRoamStartIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRoamStartIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRoamStartIndSizeof(void *msg);
 #define CsrWifiSmeRoamStartIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRoamingConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRoamingConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRoamingConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRoamingConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRoamingConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeRoamingConfigGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeRoamingConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeRoamingConfigSetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeRoamingConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeRoamingConfigSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeRoamingConfigSetCfmSizeof(void *msg);
 #define CsrWifiSmeRoamingConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeScanConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeScanConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeScanConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeScanConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeScanConfigGetCfmSizeof(void *msg);
 extern void CsrWifiSmeScanConfigGetCfmSerFree(void *msg);
 
@@ -542,8 +542,8 @@ extern void CsrWifiSmeScanConfigGetCfmSerFree(void *msg);
 #define CsrWifiSmeScanFullCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeScanFullCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeScanResultIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeScanResultIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeScanResultIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeScanResultIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeScanResultIndSizeof(void *msg);
 extern void CsrWifiSmeScanResultIndSerFree(void *msg);
 
@@ -552,38 +552,38 @@ extern void CsrWifiSmeScanResultIndSerFree(void *msg);
 #define CsrWifiSmeScanResultsFlushCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeScanResultsFlushCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeScanResultsGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeScanResultsGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeScanResultsGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeScanResultsGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeScanResultsGetCfmSizeof(void *msg);
 extern void CsrWifiSmeScanResultsGetCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeSmeStaConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSmeStaConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSmeStaConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSmeStaConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeStaConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeStaConfigGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeSmeStaConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSmeStaConfigSetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSmeStaConfigSetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSmeStaConfigSetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeStaConfigSetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeStaConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeStationMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeStationMacAddressGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeStationMacAddressGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeStationMacAddressGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeStationMacAddressGetCfmSizeof(void *msg);
 #define CsrWifiSmeStationMacAddressGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeTspecIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeTspecIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeTspecIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeTspecIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeTspecIndSizeof(void *msg);
 extern void CsrWifiSmeTspecIndSerFree(void *msg);
 
-extern u8* CsrWifiSmeTspecCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeTspecCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeTspecCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeTspecCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeTspecCfmSizeof(void *msg);
 extern void CsrWifiSmeTspecCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeVersionsGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeVersionsGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeVersionsGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeVersionsGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeVersionsGetCfmSizeof(void *msg);
 extern void CsrWifiSmeVersionsGetCfmSerFree(void *msg);
 
@@ -612,18 +612,18 @@ extern void CsrWifiSmeVersionsGetCfmSerFree(void *msg);
 #define CsrWifiSmeCloakedSsidsSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeCloakedSsidsSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeCloakedSsidsGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCloakedSsidsGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCloakedSsidsGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCloakedSsidsGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCloakedSsidsGetCfmSizeof(void *msg);
 extern void CsrWifiSmeCloakedSsidsGetCfmSerFree(void *msg);
 
-extern u8* CsrWifiSmeWifiOnIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeWifiOnIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeWifiOnIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeWifiOnIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeWifiOnIndSizeof(void *msg);
 #define CsrWifiSmeWifiOnIndSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeSmeCommonConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeSmeCommonConfigGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeSmeCommonConfigGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeSmeCommonConfigGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeSmeCommonConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeCommonConfigGetCfmSerFree CsrWifiSmePfree
 
@@ -632,23 +632,23 @@ extern size_t CsrWifiSmeSmeCommonConfigGetCfmSizeof(void *msg);
 #define CsrWifiSmeSmeCommonConfigSetCfmSizeof CsrWifiEventCsrUint16Sizeof
 #define CsrWifiSmeSmeCommonConfigSetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeInterfaceCapabilityGetCfmSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeInterfaceCapabilityGetCfmDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeInterfaceCapabilityGetCfmSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeInterfaceCapabilityGetCfmDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeInterfaceCapabilityGetCfmSizeof(void *msg);
 #define CsrWifiSmeInterfaceCapabilityGetCfmSerFree CsrWifiSmePfree
 
-extern u8* CsrWifiSmeErrorIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeErrorIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeErrorIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeErrorIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeErrorIndSizeof(void *msg);
 extern void CsrWifiSmeErrorIndSerFree(void *msg);
 
-extern u8* CsrWifiSmeInfoIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeInfoIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeInfoIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeInfoIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeInfoIndSizeof(void *msg);
 extern void CsrWifiSmeInfoIndSerFree(void *msg);
 
-extern u8* CsrWifiSmeCoreDumpIndSer(u8 *ptr, size_t *len, void *msg);
-extern void* CsrWifiSmeCoreDumpIndDes(u8 *buffer, size_t len);
+extern u8 *CsrWifiSmeCoreDumpIndSer(u8 *ptr, size_t *len, void *msg);
+extern void *CsrWifiSmeCoreDumpIndDes(u8 *buffer, size_t len);
 extern size_t CsrWifiSmeCoreDumpIndSizeof(void *msg);
 extern void CsrWifiSmeCoreDumpIndSerFree(void *msg);
 
-- 
1.7.9.5

