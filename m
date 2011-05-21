Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1EUDGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 23:06:42 -0400
Received: from snt0-omc3-s26.snt0.hotmail.com ([65.55.90.165]:2215 "EHLO
	snt0-omc3-s26.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757411Ab1EUDGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 23:06:39 -0400
Message-ID: <SNT104-W34C570E7AB5B451569B495BA700@phx.gbl>
X-Originating-IP: [125.71.231.216]
From: ym cheng <yongmingcheng@hotmail.com>
To: <geoff@geoffthorpe.net>, <linux-kernel@vger.kernel.org>
Subject: yaff2 support
Date: Sat, 21 May 2011 03:06:38 +0000
Importance: Normal
In-Reply-To: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net>
References: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 21 May 2011 03:06:39.0631 (UTC) FILETIME=[1A89D1F0:01CC1764]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4L36r5E019924


In file included from /home/ymcheng/linux-2.6.39/arch/arm/include/asm/thread_info.h:28,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/thread_info.h:53,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/preempt.h:9,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/spinlock.h:50,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/seqlock.h:29,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/time.h:8,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/stat.h:60,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from include/linux/module.h:10,
Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â  from fs/yaffs2/yaffs_fs.c:48:
/home/ymcheng/linux-2.6.39/arch/arm/include/asm/domain.h:86:1: warning: this is the location of the previous definition
fs/yaffs2/yaffs_fs.c:310: warning: initialization from incompatible pointer type
fs/yaffs2/yaffs_fs.c:380: warning: initialization from incompatible pointer type
fs/yaffs2/yaffs_fs.c:393: error: unknown field 'delete_inode' specified in initializer
fs/yaffs2/yaffs_fs.c:393: warning: initialization from incompatible pointer type
fs/yaffs2/yaffs_fs.c:394: error: unknown field 'clear_inode' specified in initializer
fs/yaffs2/yaffs_fs.c:394: warning: initialization from incompatible pointer type
fs/yaffs2/yaffs_fs.c: In function 'yaffs_delete_inode':
fs/yaffs2/yaffs_fs.c:725: error: implicit declaration of function 'clear_inode'
fs/yaffs2/yaffs_fs.c: In function 'yaffs_setattr':
fs/yaffs2/yaffs_fs.c:1703: error: implicit declaration of function 'inode_setattr'
fs/yaffs2/yaffs_fs.c: In function 'yaffs_internal_read_super':
fs/yaffs2/yaffs_fs.c:2498: error: implicit declaration of function 'init_MUTEX'
fs/yaffs2/yaffs_fs.c: In function 'yaffs_read_super':
fs/yaffs2/yaffs_fs.c:2562: error: implicit declaration of function 'get_sb_bdev'
fs/yaffs2/yaffs_fs.c: At top level:
fs/yaffs2/yaffs_fs.c:2579: error: unknown field 'get_sb' specified in initializer
fs/yaffs2/yaffs_fs.c:2579: warning: initialization makes integer from pointer without a cast
fs/yaffs2/yaffs_fs.c:2626: error: unknown field 'get_sb' specified in initializer
fs/yaffs2/yaffs_fs.c:2626: warning: initialization makes integer from pointer without a cast
make[2]: *** [fs/yaffs2/yaffs_fs.o] é”™è¯¯ 1
make[1]: *** [fs/yaffs2] é”™è¯¯ 2



My board is 23c2440 kernel version:2.6.39.

 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
