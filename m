Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1LAJzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:55:05 -0500
Received: from host86-160-104-251.range86-160.btcentralplus.com ([86.160.104.251]:38318
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1LAJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:55:04 -0500
X-Greylist: delayed 852 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 04:55:04 EST
Message-ID: <4ED74B9D.7070502@oak.selfip.net>
Date: Thu, 01 Dec 2011 09:40:45 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Build warnings - v3.2-rc3-187-g11d814a
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  Noticed the build warnings below from v3.2-rc3-187-g11d814a.

$ gcc --version
gcc (Gentoo Hardened 4.6.2 p1.0, pie-0.4.5) 4.6.2

$ uname -a
Linux s1 3.2.0-rc3 #97 SMP Fri Nov 25 10:17:10 GMT 2011 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

...
  CC      fs/binfmt_misc.o
In file included from ~/git/linux/arch/x86/include/asm/uaccess.h:573:0,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from fs/binfmt_misc.c:26:
~/git/linux/arch/x86/include/asm/uaccess_32.h: In function 'parse_command.part.2':
~/git/linux/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
...
  CC      drivers/md/dm-table.o
drivers/md/dm-table.c: In function 'dm_table_set_integrity':
drivers/md/dm-table.c:1285:3: warning: statement with no effect [-Wunused-value]
...
  CC      drivers/usb/host/ohci-hcd.o
In file included from drivers/usb/host/ohci-hcd.c:101:0:
drivers/usb/host/ohci-dbg.c: In function 'fill_registers_buffer':
drivers/usb/host/ohci-dbg.c:642:2: warning: the comparison will always evaluate as 'true' for the address of 'next' will never be NULL [-Waddress]
drivers/usb/host/ohci-dbg.c:661:3: warning: the comparison will always evaluate as 'true' for the address of 'next' will never be NULL [-Waddress]
...
  HOSTCC  arch/x86/boot/compressed/relocs
arch/x86/boot/compressed/relocs.c: In function 'print_absolute_symbols':
arch/x86/boot/compressed/relocs.c:405:14: warning: variable 'sh_symtab' set but not used [-Wunused-but-set-variable]
arch/x86/boot/compressed/relocs.c: In function 'emit_relocs':
arch/x86/boot/compressed/relocs.c:605:9: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result [-Wunused-result]
arch/x86/boot/compressed/relocs.c:612:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result [-Wunused-result]

  Regards,

Dave.


