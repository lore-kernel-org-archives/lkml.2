Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2CLAsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:48:17 -0400
Received: from 1wt.eu ([62.212.114.60]:63025 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2CLAsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:11 -0400
Message-Id: <20120312002045.940083732@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 00/12] 2.6.32.59-longterm review
Message-ID: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.59 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made within 72 hours. Anything received after that time
might be too late.

Please note that the whole -rc patch is not provided anymore, only individual
patches are provided so that their authors and subsystem maintainers can spot
issues. If this is a problem for you, please report it so that we try to find
a solution.

The diffstat is appended below.

 arch/ia64/Kconfig             |   17 -----------------
 arch/s390/Kconfig             |    3 +++
 arch/s390/kernel/setup.c      |    1 +
 block/bsg.c                   |    3 ++-
 drivers/net/usb/usbnet.c      |    2 ++
 drivers/watchdog/hpwdt.c      |    5 +++--
 fs/binfmt_elf.c               |    2 +-
 fs/cifs/dir.c                 |   20 ++++++++++++++++++--
 fs/ecryptfs/crypto.c          |   21 +++++++++++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |    2 ++
 fs/ecryptfs/file.c            |    3 ++-
 fs/ecryptfs/inode.c           |   18 +++---------------
 include/linux/backing-dev.h   |    1 +
 include/linux/regset.h        |   10 ++++++++--
 mm/backing-dev.c              |   15 ++++++++++-----
 mm/page-writeback.c           |    1 +
 net/mac80211/rate.c           |    2 +-
 17 files changed, 79 insertions(+), 47 deletions(-)


