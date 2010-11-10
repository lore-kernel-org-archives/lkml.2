Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0KJTtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:49:12 -0500
Received: from mailq1.tnnet.fi ([217.112.240.127]:48123 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0KJTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:49:10 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 14:49:10 EST
Message-ID: <4CDAF540.5D31D8C6@users.sourceforge.net>
Date: Wed, 10 Nov 2010 21:40:48 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.5a file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed device open/close reference count race, again. The fix in previous
  version was not complete enough. Thanks to John Fitzgerald for
  reporting/testing this problem.
- Worked around block layer interface breakage on linux-2.6.37-rc kernels
  (FLUSH/FUA changes).
- Cleaned up lots of #ifdef spaghetti code for 2.6.37 and later kernels.
- Added "lo_threads" option for 2.6.37 and later kernels. This can be used
  to configure the number of helper threads for device backed loops.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.5a.tar.bz2
    md5sum 9477960fb543938cec4f63a0eb365b12

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.5a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
