Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2EGHfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:35:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56992 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab2EGHfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:35:31 -0400
MIME-Version: 1.0
Date: Mon, 7 May 2012 15:35:30 +0800
Message-ID: <CAD+1EGOKQugnnFSn6DvPfod+5O5c+bNSE7878XM7yPY3bXxPaA@mail.gmail.com>
Subject: [Patch]Fix a mistake sentence in the file 'Documentation/zh_CN/magic-number.txt'
From: harryxiyou <harryxiyou@gmail.com>
To: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Shuanglong Zhang <zhangsl16@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q477ZhAa016897

Hi Greg,

This is a patch for correcting a mistake sentence in the file
Documentation/zh_CN/magic-number.txt. The patch is like
the following one. If you have any other questions, please let
me know ;-)

signed-off-by: Harry Wei <harryxiyou@gmail.com>
Reported-by: Zhang Shuanglong <zhangsl16@gmail.com>
---
 Documentation/zh_CN/magic-number.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/zh_CN/magic-number.txt
b/Documentation/zh_CN/magic-number.txt
index f606ba8..4263022 100644
--- a/Documentation/zh_CN/magic-number.txt
+++ b/Documentation/zh_CN/magic-number.txt
@@ -160,7 +160,7 @@ QUEUE_MAGIC_USED      0xf7e1cc33  queue_entry
 drivers/scsi/arm/queue.c
 HTB_CMAGIC            0xFEFAFEF1  htb_class         net/sched/sch_htb.c
 NMI_MAGIC             0x48414d4d455201 nmi_s
arch/mips/include/asm/sn/nmi.h

-请注意，在声音记忆管理中仍然有每一些被定义的驱动魔术值。查看include/sound/sndmagic.h来获取他们完整的列表信息。很多OSS声音驱动拥有自己从声卡PCI
ID构建的魔术值-他们也没有被列在这里。
+请注意，在声音记忆管理中仍然有一些特殊的为每个驱动定义的魔术值。查看include/sound/sndmagic.h来获取他们完整的列表信息。很多OSS声音驱动拥有自己从声卡PCI
ID构建的魔术值-他们也没有被列在这里。

 IrDA子系统也使用了大量的自己的魔术值，查看include/net/irda/irda.h来获他们完整的信息。

-- 
1.7.0.4
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
