Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2JQKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:14:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2JQKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:13:59 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 7/7] staging: csr: csr_wifi_sme_sef.h: Fixed lines over 80 chars per line
Date: Wed, 17 Oct 2012 19:11:07 +0900
Message-Id: <1350468667-2406-7-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350468667-2406-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350468667-2406-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed lines over 80 characters per line.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_sme_sef.h |  150 +++++++++++++++++++++-----------
 1 file changed, 100 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_sme_sef.h b/drivers/staging/csr/csr_wifi_sme_sef.h
index 3598bb8..4456fb3 100644
--- a/drivers/staging/csr/csr_wifi_sme_sef.h
+++ b/drivers/staging/csr/csr_wifi_sme_sef.h
@@ -19,80 +19,130 @@ extern "C" {
 
 typedef void (*CsrWifiSmeStateHandlerType)(void *drvpriv, CsrWifiFsmEvent *msg);
 
-extern const CsrWifiSmeStateHandlerType CsrWifiSmeUpstreamStateHandlers[CSR_WIFI_SME_PRIM_UPSTREAM_COUNT];
+extern const CsrWifiSmeStateHandlerType
+	CsrWifiSmeUpstreamStateHandlers[CSR_WIFI_SME_PRIM_UPSTREAM_COUNT];
 
 
 extern void CsrWifiSmeActivateCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeAdhocConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeAdhocConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeAssociationCompleteIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeAssociationStartIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeBlacklistCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCalibrationDataGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCalibrationDataSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCcxConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCcxConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCoexConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCoexConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCoexInfoGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeAdhocConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeAdhocConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeAssociationCompleteIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeAssociationStartIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeBlacklistCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCalibrationDataGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCalibrationDataSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCcxConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCcxConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCoexConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCoexConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCoexInfoGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeConnectCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeConnectionConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeConnectionInfoGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeConnectionQualityIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeConnectionStatsGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeConnectionConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeConnectionInfoGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeConnectionQualityIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeConnectionStatsGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeDeactivateCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeDisconnectCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeEventMaskSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeHostConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeHostConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeIbssStationIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeEventMaskSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeHostConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeHostConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeIbssStationIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeKeyCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeLinkQualityGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeMediaStatusIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeMibConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeMibConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeLinkQualityGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeMediaStatusIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeMibConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeMibConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeMibGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeMibGetNextCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeMibSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeMicFailureIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeMulticastAddressCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmePacketFilterSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmePermanentMacAddressGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmePmkidCandidateListIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeMulticastAddressCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmePacketFilterSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmePermanentMacAddressGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmePmkidCandidateListIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmePmkidCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmePowerConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmePowerConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeRegulatoryDomainInfoGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeRoamCompleteIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmePowerConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmePowerConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeRegulatoryDomainInfoGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeRoamCompleteIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeRoamStartIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeRoamingConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeRoamingConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeScanConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeScanConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeRoamingConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeRoamingConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeScanConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeScanConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeScanFullCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeScanResultIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeScanResultsFlushCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeScanResultsGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeSmeStaConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeSmeStaConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeStationMacAddressGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeScanResultsFlushCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeScanResultsGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeSmeStaConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeSmeStaConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeStationMacAddressGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeTspecIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeTspecCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeVersionsGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeWifiFlightmodeCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeVersionsGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeWifiFlightmodeCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeWifiOffIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeWifiOffCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeWifiOnCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCloakedSsidsSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeCloakedSsidsGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCloakedSsidsSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeCloakedSsidsGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeWifiOnIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeSmeCommonConfigGetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeSmeCommonConfigSetCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeGetInterfaceCapabilityCfmHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeSmeCommonConfigGetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeSmeCommonConfigSetCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeGetInterfaceCapabilityCfmHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeErrorIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeInfoIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
 extern void CsrWifiSmeCoreDumpIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
-extern void CsrWifiSmeAmpStatusChangeIndHandler(void *drvpriv, CsrWifiFsmEvent *msg);
+extern void CsrWifiSmeAmpStatusChangeIndHandler(void *drvpriv,
+	CsrWifiFsmEvent *msg);
 
 #ifdef __cplusplus
 }
-- 
1.7.9.5

