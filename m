Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2I0Pgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:36:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2I0Pgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:36:40 -0400
Date: Thu, 27 Sep 2012 23:36:33 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@vger.linux-kernel.cn,
        "Eric W. Biederman" <ebiederman@xmission.com>
Subject: [PATCH]Documentation:Chinese translation of Documentation/IRQ.txt
Message-ID: <20120927153633.GA4564@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Chinese translated version of
Documentation/IRQ.txt

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/IRQ.txt |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/zh_CN/IRQ.txt

diff --git a/Documentation/zh_CN/IRQ.txt b/Documentation/zh_CN/IRQ.txt
new file mode 100644
index 0000000..956026d
--- /dev/null
+++ b/Documentation/zh_CN/IRQ.txt
@@ -0,0 +1,39 @@
+Chinese translated version of Documentation/IRQ.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Eric W. Biederman <ebiederman@xmission.com>
+Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+---------------------------------------------------------------------
+Documentation/IRQ.txt 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+英文版维护者： Eric W. Biederman <ebiederman@xmission.com>
+中文版维护者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
+中文版翻译者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
+中文版校译者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
+
+
+以下为正文
+---------------------------------------------------------------------
+何为 IRQ?
+
+一个 IRQ 是来自某个设备的一个中断请求。目前，它们可以来自一个硬件引脚，
+或来自一个数据包。多个设备可能连接到同个硬件引脚，从而共享一个 IRQ。
+
+一个 IRQ 编号是用于告知硬件中断源的内核标识。通常情况下，这是一个
+全局 irq_desc 数组的索引，但是除了在 linux/interrupt.h 中的实现，
+具体的细节是体系结构特定的。
+
+一个 IRQ 编号是设备上某个可能的中断源的枚举。通常情况下，枚举的编号是
+该引脚在系统内中断控制器的所有输入引脚中的编号。对于 ISA 总线中的情况，
+枚举的是在两个 i8259 中断控制器中 16 个输入引脚。
+
+架构可以对 IRQ 编号指定额外的含义，在硬件涉及任何手工配置的情况下，
+是被提倡的。ISA 的 IRQ 是一个分配这类额外含义的典型例子。
-- 
1.7.9.5

