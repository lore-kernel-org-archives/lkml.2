Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0LIJjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:39:17 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53331 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab0LIJjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:39:15 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 009/211] unicore32: new file arch/unicore32/boot/compressed/piggy.S.in
Date: Thu, 9 Dec 2010 17:39:12 +0800
Message-ID: <01dc01cb9784$efcfee90$cf6fcbb0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhOndi4v1fnkxTlavQCvxICqvEA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	this file generate piggy.S, and then piggy.gzip, or so

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/boot/compressed/piggy.S.in |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/boot/compressed/piggy.S.in
b/arch/unicore32/boot/compressed/piggy.S.in
new file mode 100644
index 0000000..b79704d
--- /dev/null
+++ b/arch/unicore32/boot/compressed/piggy.S.in
@@ -0,0 +1,6 @@
+	.section .piggydata,#alloc
+	.globl	input_data
+input_data:
+	.incbin	"arch/unicore32/boot/compressed/piggy.DECOMP_SUFFIX"
+	.globl	input_data_end
+input_data_end:

