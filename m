Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0LIJmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:42:37 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:52003 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0LIJmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:42:35 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 013/211] unicore32: new file arch/unicore32/include/asm/Kbuild
Date: Thu, 9 Dec 2010 17:42:32 +0800
Message-ID: <01e401cb9785$672b5a10$35820e30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhWVWocyffPMUQ4CzsE1KPvIqTw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	simple Kbuild file for asm-headers

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/Kbuild |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/Kbuild
b/arch/unicore32/include/asm/Kbuild
new file mode 100644
index 0000000..c43b56c
--- /dev/null
+++ b/arch/unicore32/include/asm/Kbuild
@@ -0,0 +1,4 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += hwcap.h
+

