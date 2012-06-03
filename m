Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2FCQjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 12:39:45 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:1880 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab2FCQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 12:39:44 -0400
Message-ID: <1338741582.19914.6.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] parisc: cleanup quoted include
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 03 Jun 2012 18:39:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Jun 2012 16:39:42.0701 (UTC) FILETIME=[7A12D1D0:01CD41A7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quoted include starts with a superfluous "./". Clean up that quoted
include.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested: I have neither the hardware nor the toolchain involved. Looks
obviously correct, though.

 drivers/parisc/iosapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 1f9e9fe..69ff608 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -146,7 +146,7 @@
 #endif
 
 #include <asm/ropes.h>
-#include "./iosapic_private.h"
+#include "iosapic_private.h"
 
 #define MODULE_NAME "iosapic"
 
-- 
1.7.7.6



