Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2LPBXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 20:23:40 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41630 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2LPBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 20:23:39 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 09:23:38 +0800
Message-ID: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
Subject: /usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No such
 file or directory
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How should the symbolic links be setup to compile the latest kernel?


Currently I had these links and kernels compiled fine until 2 days ago.

         asm -> /usr/src/linux/include/uapi/asm-generic/
         asm-generic -> /usr/src/linux/include/uapi/asm-generic
         linux -> /usr/src/linux/include/uapi/linux


# make
make[1]: Nothing to be done for `all'.
  HOSTCC  arch/x86/tools/relocs
In file included from /usr/include/bits/errno.h:24:0,
                 from /usr/include/errno.h:35,
                 from arch/x86/tools/relocs.c:6:
/usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No such
file or directory
compilation terminated.
make[1]: *** [arch/x86/tools/relocs] Error 1
make: *** [archscripts] Error 2


Thanks,
Jeff
