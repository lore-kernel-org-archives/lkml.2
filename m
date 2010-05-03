Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0ECJud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:50:33 -0400
Received: from mail.turknet.net.tr ([193.192.98.182]:35005 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab0ECJub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:50:31 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 05:50:31 EDT
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux-2.6.33.3-rt19 Compile Error With PohmelFS
Date: Mon, 3 May 2010 12:40:23 +0300
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5-6-desktop; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005031240.23858.tarkan.erimer@turknet.net.tr>
X-OriginalArrivalTime: 03 May 2010 09:40:15.0933 (UTC) FILETIME=[A2BD46D0:01CAEAA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an openSUSE 11.3 Milestone 6 with GCC-4.5. When I tried to compile, I 
got the following error message related to inode.c. 

Tarkan

  CC      drivers/staging/staging.o
  LD      drivers/staging/built-in.o
  LD      drivers/staging/pohmelfs/built-in.o
  CC [M]  drivers/staging/pohmelfs/inode.o
drivers/staging/pohmelfs/inode.c: In function ‘pohmelfs_put_super’:
drivers/staging/pohmelfs/inode.c:1293:3: warning: passing argument 1 of 
‘atomic_read’ from incompatible pointer type
/usr/src/linux-2.6.33.3/arch/x86/include/asm/atomic_64.h:21:19: note: expected 
‘const struct atomic_t *’ but argument is of type ‘unsigned int *’
drivers/staging/pohmelfs/inode.c:1296:6: warning: passing argument 1 of 
‘atomic_read’ from incompatible pointer type
/usr/src/linux-2.6.33.3/arch/x86/include/asm/atomic_64.h:21:19: note: expected 
‘const struct atomic_t *’ but argument is of type ‘unsigned int *’
drivers/staging/pohmelfs/inode.c:1297:4: warning: passing argument 1 of 
‘atomic_read’ from incompatible pointer type
/usr/src/linux-2.6.33.3/arch/x86/include/asm/atomic_64.h:21:19: note: expected 
‘const struct atomic_t *’ but argument is of type ‘unsigned int *’
drivers/staging/pohmelfs/inode.c:1305:2: error: request for member ‘next’ in 
something not a structure or union
drivers/staging/pohmelfs/inode.c:1305:2: warning: comparison of distinct 
pointer types lacks a cast
drivers/staging/pohmelfs/inode.c:1317:3: warning: passing argument 1 of 
‘atomic_read’ from incompatible pointer type
/usr/src/linux-2.6.33.3/arch/x86/include/asm/atomic_64.h:21:19: note: expected 
‘const struct atomic_t *’ but argument is of type ‘unsigned int *’
make[5]: *** [drivers/staging/pohmelfs/inode.o] Error 1
make[4]: *** [drivers/staging/pohmelfs] Error 2
make[3]: *** [drivers/staging] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [binrpm-pkg] Error 2
make: *** [binrpm-pkg] Error 2

