Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab2HQA3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:29:17 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42581
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932638Ab2HQA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:28:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 11/14] Tools: hv: Rename the function kvp_get_ip_address()
Date: Thu, 16 Aug 2012 17:45:22 -0700
Message-Id: <1345164325-5198-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345164325-5198-1-git-send-email-kys@microsoft.com>
References: <1345164300-5146-1-git-send-email-kys@microsoft.com>
 <1345164325-5198-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/hv/hv_kvp_daemon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 59669a8..bb2a6c4 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -766,7 +766,7 @@ static int kvp_process_ip_address(void *addrp,
 }
 
 static int
-kvp_get_ip_address(int family, char *if_name, int op,
+kvp_get_ip_info(int family, char *if_name, int op,
 		 void  *out_buffer, int length)
 {
 	struct ifaddrs *ifap;
@@ -1469,12 +1469,12 @@ int main(void)
 			strcpy(key_value, lic_version);
 			break;
 		case NetworkAddressIPv4:
-			kvp_get_ip_address(AF_INET, NULL, KVP_OP_ENUMERATE,
+			kvp_get_ip_info(AF_INET, NULL, KVP_OP_ENUMERATE,
 				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv4");
 			break;
 		case NetworkAddressIPv6:
-			kvp_get_ip_address(AF_INET6, NULL, KVP_OP_ENUMERATE,
+			kvp_get_ip_info(AF_INET6, NULL, KVP_OP_ENUMERATE,
 				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv6");
 			break;
-- 
1.7.4.1

