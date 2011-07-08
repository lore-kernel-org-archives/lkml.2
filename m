Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1GHQwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:52:34 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:46112 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1GHQwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:52:33 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jul 2011 12:52:33 EDT
Message-ID: <4E173451.DD55B8DF@users.sourceforge.net>
Date: Fri, 08 Jul 2011 19:46:09 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.6d file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- build-initrd.sh is now able to set up more than one loop device.
- Fixed build on 3.x kernels.
- Lots of #ifdef spaghetti removed for 3.x kernels.
- Fixed build on recent RHEL kernels.


bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6d.tar.bz2
    md5sum a8b88ae368e1fcbcc073adf28fdfeb1a

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6d.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
