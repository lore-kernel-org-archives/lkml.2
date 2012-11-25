Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2KYOMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 09:12:19 -0500
Received: from mailq1.tnnet.fi ([217.112.240.127]:53123 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2KYOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 09:12:17 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2012 09:12:17 EST
Message-ID: <50B22586.323A283A@users.sourceforge.net>
Date: Sun, 25 Nov 2012 16:04:54 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.6g file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed bug that could cause hang if backing device is stacking device, for
  example /dev/md* device. Many thanks to Norbert Warmuth for reporting and
  chasing this bug.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6g.tar.bz2
    md5sum ffe4aee7004cdac8d181f2d64f4d51a8

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6g.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
