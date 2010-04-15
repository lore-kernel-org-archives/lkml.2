Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0DOTMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:12:38 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:2214 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755466Ab0DOTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:12:37 -0400
X-SpamScore: -1
X-BigFish: VS-1(z5edIzab9bhzz1202hzzz2dh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4BC764E6.40002@infradead.org>
Date: Thu, 15 Apr 2010 12:11:34 -0700
From: Geoff Levand <geoff@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       "cbe-oss-dev@lists.ozlabs.org" <cbe-oss-dev@lists.ozlabs.org>
Subject: [patch] ps3: Update platform maintainer
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2010 19:12:22.0422 (UTC) FILETIME=[937C5360:01CADCCF]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the PS3 entries in the MAINTAINERS file.

Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4482,17 +4482,17 @@ S:	Maintained
 F:	drivers/ata/sata_promise.*
 
 PS3 NETWORK SUPPORT
-M:	Geoff Levand <geoffrey.levand@am.sony.com>
+M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
 L:	cbe-oss-dev@ozlabs.org
-S:	Supported
+S:	Maintained
 F:	drivers/net/ps3_gelic_net.*
 
 PS3 PLATFORM SUPPORT
-M:	Geoff Levand <geoffrey.levand@am.sony.com>
+M:	Geoff Levand <geoff@infradead.org>
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
-S:	Supported
+S:	Maintained
 F:	arch/powerpc/boot/ps3*
 F:	arch/powerpc/include/asm/lv1call.h
 F:	arch/powerpc/include/asm/ps3*.h

