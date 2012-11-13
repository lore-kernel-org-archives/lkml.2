Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2KMT53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:57:29 -0500
Received: from mailq2.tnnet.fi ([217.112.254.233]:36341 "EHLO mailq2.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab2KMT51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:57:27 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2012 14:57:27 EST
Message-ID: <50A2A3CE.7DDB8A48@users.sourceforge.net>
Date: Tue, 13 Nov 2012 21:47:26 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.6f file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Worked around block layer interface changes on 3.7-rc kernels.
- Fixed bug that caused loop device to report un-optimal I/O size on some
  backing devices. This bug caused bad performance.
- Fixed bug that assumed /bin/sh -> bash. For /bin/sh -> dash case some
  auto-detections failed.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6f.tar.bz2
    md5sum 0b5bfe4538fd8439b84c586846726507

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.6f.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
