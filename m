Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1C3ItV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:49:21 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:37135 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab1C3ItU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:49:20 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>, "'Huang Weiyi'" <weiyi.huang@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] unicore32 core architecture: remove duplicated #include
Date: Wed, 30 Mar 2011 16:49:11 +0800
Message-ID: <01ec01cbeeb7$5728d230$057a7690$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acvut0qubuwIrythRVSRrxBwY0e1Hg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include('s) in
  arch/unicore32/kernel/traps.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/traps.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
index 25abbb1..254e36f 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 #include <linux/atomic.h>
 #include <linux/unistd.h>
 
-- 
1.6.2.2


