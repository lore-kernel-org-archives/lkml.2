Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391Ab2FHRAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:00:22 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1930 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760669Ab2FHRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:00:21 -0400
Message-ID: <1339174815.30984.8.camel@x61.thuisdomein>
Subject: [PATCH] avr32: Remove unused asm/numnodes.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 19:00:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 17:00:16.0538 (UTC) FILETIME=[2D9027A0:01CD4598]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is handled with config options now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Previous, inspirational, patch:
    30957a8 ("[SPARC64]: Remove unused asm-sparc64/numnodes.h")

1) Tested basically like this:
    $ git grep -n "numnodes\.h"
    $ git grep -n "define[[:space:]]*NODES_SHIFT\b"
    arch/avr32/include/asm/numnodes.h:5:#define NODES_SHIFT 2
    include/linux/numa.h:6:#define NODES_SHIFT     CONFIG_NODES_SHIFT
    include/linux/numa.h:8:#define NODES_SHIFT     0
    $

 arch/avr32/include/asm/numnodes.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)
 delete mode 100644 arch/avr32/include/asm/numnodes.h

diff --git a/arch/avr32/include/asm/numnodes.h b/arch/avr32/include/asm/numnodes.h
deleted file mode 100644
index 0b864d7..0000000
--- a/arch/avr32/include/asm/numnodes.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_AVR32_NUMNODES_H
-#define __ASM_AVR32_NUMNODES_H
-
-/* Max 4 nodes */
-#define NODES_SHIFT	2
-
-#endif /* __ASM_AVR32_NUMNODES_H */
-- 
1.7.7.6

