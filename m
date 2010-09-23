Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0IWOyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:54:08 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:39904 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0IWOyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:54:07 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 10:54:07 EDT
Message-ID: <4C9B679F.C9507D95@users.sourceforge.net>
Date: Thu, 23 Sep 2010 17:43:43 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.4b file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Worked around block layer interface breakage on linux-2.6.36-rc kernels.
- Added workaround for device open/close reference count race. This race
  caused random loop-AES "make tests" failures with "ioctl: LOOP_CLR_FD:
  Device or resource busy" error message. The workaround is in util-linux
  patch (new mount/umount/losetup/swapon binaries). Thanks to Julien
  Moutinho for reporting/testing this problem.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.4b.tar.bz2
    md5sum 5552e8a2572c5fa416a28493f9e0ec8f

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.4b.tar.bz2.sign

Workaround for device open/close reference count race, for older util-linux
versions:

    http://loop-aes.sourceforge.net/updates/util-linux-sync_fix-20100920.diff.bz2
    http://loop-aes.sourceforge.net/updates/util-linux-sync_fix-20100920.diff.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
