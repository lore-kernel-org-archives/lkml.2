Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2J1DSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 23:18:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64067 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2J1DSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 23:18:11 -0400
Date: Sun, 28 Oct 2012 11:17:59 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Documentation: Fixes a term's translation in
 Documentation/zh_CN/arm64/memory.txt
Message-ID: <20121028031758.GA3834@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a term's translation in Documentation/zh_CN/arm64/memory.txt
The modification is based on Catalin Marinas <catalin.marinas@arm.com>'s
suggestion:
    "memory" in "ffffffc000000000 ffffffffffffffff 256GB memory"
    should  be treated as "kernel logical memory map",
    so the translation should be "内核逻辑内存映射".

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/arm64/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/zh_CN/arm64/memory.txt b/Documentation/zh_CN/arm64/memory.txt
index 83b5193..2a74499 100644
--- a/Documentation/zh_CN/arm64/memory.txt
+++ b/Documentation/zh_CN/arm64/memory.txt
@@ -61,7 +61,7 @@ ffffffbe00000000	ffffffbffbffffff	  ~8GB		[防护页，未来用于 vmmemap]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		模块
 
-ffffffc000000000	ffffffffffffffff	 256GB		内存空间
+ffffffc000000000	ffffffffffffffff	 256GB		内核逻辑内存映射
 
 
 4KB 页大小的转换表查找：
-- 
1.7.9.5

