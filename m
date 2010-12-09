Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0LIJoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:44:07 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:52009 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab0LIJoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:44:04 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 015/211] unicore32: new file arch/unicore32/include/asm/auxvec.h
Date: Thu, 9 Dec 2010 17:44:02 +0800
Message-ID: <01e801cb9785$9c7a81f0$d56f85d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhZwhYx/XbCI0QeyaTcESCcYTYA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	auxvec.h only for dependency

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/auxvec.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/auxvec.h
b/arch/unicore32/include/asm/auxvec.h
new file mode 100644
index 0000000..b1a883a
--- /dev/null
+++ b/arch/unicore32/include/asm/auxvec.h
@@ -0,0 +1,4 @@
+#ifndef __UNICORE_AUXVEC_H__
+#define __UNICORE_AUXVEC_H__
+
+#endif

