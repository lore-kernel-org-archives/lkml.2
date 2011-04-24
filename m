Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1DXVIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:08:14 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:47076 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756384Ab1DXVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:08:12 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB490FE.4020706@verizon.net>
Date: Sun, 24 Apr 2011 17:07:10 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <liqin.chen@sunplusct.com>, <lennox.wu@gmail.com>
Subject: [PATCH] arch: score: use cc-cross-prefix to set CROSS_COMPILE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the score Makefile to use cc-cross-prefix
to only set CROSS_COMPILE if score-linux-gcc exists.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/score/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/score/Makefile b/arch/score/Makefile
index 974aefe..2807216 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -7,7 +7,7 @@
 #

 KBUILD_DEFCONFIG := spct6600_defconfig
-CROSS_COMPILE := score-linux-
+CROSS_COMPILE := $(call cc-cross-prefix, score-linux-)

 #
 # CPU-dependent compiler/assembler options for optimization.
-- 
1.7.5.rc1

