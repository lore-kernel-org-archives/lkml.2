Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2KRKCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 05:02:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KRKC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 05:02:29 -0500
Date: Sun, 18 Nov 2012 18:02:21 +0800
From: Fu Wei <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg Kroah Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Doc ML <linux-doc@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH]Documentation:Update Documentation/zh_CN/arm64/memory.txt
Message-ID: <20121118100057.GA20057@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a update of Chinese
documentation:Documentation/zh_CN/arm64/memory.txt

It is based on the modifications of Documentation/arm64/memory.txt in
submission :"e3978cde".

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/arm64/memory.txt | 12 ++++++------
 1 个文件被修改，插入 6 行(+)，删除 6 行(-)

diff --git a/Documentation/zh_CN/arm64/memory.txt b/Documentation/zh_CN/arm64/memory.txt
index 2a74499..a5f6283 100644
--- a/Documentation/zh_CN/arm64/memory.txt
+++ b/Documentation/zh_CN/arm64/memory.txt
@@ -47,17 +47,17 @@ AArch64 Linux 内存布局：
 -----------------------------------------------------------------------
 0000000000000000	0000007fffffffff	 512GB		用户空间
 
-ffffff8000000000	ffffffbbfffcffff	~240GB		vmalloc
+ffffff8000000000	ffffffbbfffeffff	~240GB		vmalloc
 
-ffffffbbfffd0000	ffffffbcfffdffff	  64KB		[防护页]
+ffffffbbffff0000	ffffffbbffffffff	  64KB		[防护页]
 
-ffffffbbfffe0000	ffffffbcfffeffff	  64KB		PCI I/O 空间
+ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
-ffffffbbffff0000	ffffffbcffffffff	  64KB		[防护页]
+ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[防护页，未来用于 vmmemap]
 
-ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
+ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O 空间
 
-ffffffbe00000000	ffffffbffbffffff	  ~8GB		[防护页，未来用于 vmmemap]
+ffffffbbffff0000	ffffffbcffffffff	  ~2MB		[防护页]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		模块
 
-- 
1.7.11.7

