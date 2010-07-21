Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab0GUHFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:05:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51194 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab0GUHFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:05:47 -0400
Date: Wed, 21 Jul 2010 16:05:53 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: axboe@kernel.dk, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] typo fix: Kconfig.debug: FAIL_IO_TIMEOUT: Faul -> Fault
Message-Id: <20100721160553.26dd6282.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is this typo already fixed in anybody's tree?
I think this is config's description and worth fixing.

Thanks,

==
The last 't' of 'fault' is missing in the description of FAIL_IO_TIMEOUT.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..dfdc034 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -937,7 +937,7 @@ config FAIL_MAKE_REQUEST
 	  Provide fault-injection capability for disk IO.
 
 config FAIL_IO_TIMEOUT
-	bool "Faul-injection capability for faking disk interrupts"
+	bool "Fault-injection capability for faking disk interrupts"
 	depends on FAULT_INJECTION && BLOCK
 	help
 	  Provide fault-injection capability on end IO handling. This
-- 
1.7.0.4

