Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0CRMrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 08:47:32 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:34083 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0CRMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 08:47:31 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 08:47:31 EDT
Message-ID: <4BA21E5D.AA5844AC@users.sourceforge.net>
Date: Thu, 18 Mar 2010 14:36:45 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.3a file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed build-initrd.sh so that initramfs type initrd (USEPIVOT=2) works
  with linux software raid devices (/dev/md0 & co). Default pivot_root type
  initrd (USEPIVOT=1) was/is ok. Patch from Hauke Johannknecht.
- build-initrd.sh now prefers to copy .static version of a program if such
  version exists. Patch from Hank Leininger.
- Worked around block layer interface changes on linux-2.6.34-rc1 kernel.
- Fixed autodetection of optimized assembler code. autoconf.h file was moved
  in 2.6.33 kernel, which caused incorrect autodetected default.
- Added support for new Intel AES instructions.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.3a.tar.bz2
    md5sum 5f12372c975b986a82e8fcf8dc107bfb

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.3a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
