Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2IEUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:32:53 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41383
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759379Ab2IEUc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:32:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V5 5/6] Tools: hv: Rename the function kvp_get_ip_address()
Date: Wed,  5 Sep 2012 13:50:14 -0700
Message-Id: <1346878215-30863-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346878215-30863-1-git-send-email-kys@microsoft.com>
References: <1346878188-30822-1-git-send-email-kys@microsoft.com>
 <1346878215-30863-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function kvp_get_ip_address() to better reflect the functionality
being implemented.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index ac144b9..849c438 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -765,7 +765,7 @@ static int kvp_process_ip_address(void *addrp,
 }
 
 static int
-kvp_get_ip_address(int family, char *if_name, int op,
+kvp_get_ip_info(int family, char *if_name, int op,
 		 void  *out_buffer, int length)
 {
 	struct ifaddrs *ifap;
@@ -1468,12 +1468,12 @@ int main(void)
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

