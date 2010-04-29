Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0D3ThF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:37:05 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52647 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757951Ab0D3Tff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:35:35 -0400
From: Florian Westphal <fwestphal@astaro.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Florian Westphal <fwestphal@astaro.com>,
       James Chapman <jchapman@katalix.com>
Subject: [PATCH] compat_ioctl: add compat handler for PPPIOCGL2TPSTATS ioctl
Date: Thu, 29 Apr 2010 10:03:22 +0200
Message-Id: <1272528202-7103-1-git-send-email-fwestphal@astaro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes following error:
ioctl32(openl2tpd:7480): Unknown cmd fd(14) cmd(80487436){t:'t';sz:72} arg(ffa7e6c0) on socket:[105094]

Cc: James Chapman <jchapman@katalix.com>
Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 fs/compat_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c32a1b6..d7957d4 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1101,6 +1101,7 @@ COMPATIBLE_IOCTL(PPPIOCCONNECT)
 COMPATIBLE_IOCTL(PPPIOCDISCONN)
 COMPATIBLE_IOCTL(PPPIOCATTCHAN)
 COMPATIBLE_IOCTL(PPPIOCGCHAN)
+COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
 /* PPPOX */
 COMPATIBLE_IOCTL(PPPOEIOCSFWD)
 COMPATIBLE_IOCTL(PPPOEIOCDFWD)
-- 
1.6.3.3

