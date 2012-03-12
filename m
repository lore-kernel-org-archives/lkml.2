Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2CLAuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:09 -0400
Received: from 1wt.eu ([62.212.114.60]:63066 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab2CLAsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:40 -0400
Message-Id: <20120312004411.301257231@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 00/13] 2.6.27.62-longterm review
Message-ID: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.27.62 release.
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

 arch/powerpc/include/asm/ppc_asm.h |    1 +
 arch/powerpc/include/asm/reg.h     |   45 +++++++++++++++++++++++++++++++++++-
 drivers/cdrom/cdrom.c              |    8 +-----
 drivers/infiniband/hw/mlx4/mad.c   |    7 +----
 drivers/video/atmel_lcdfb.c        |    2 +-
 fs/ecryptfs/file.c                 |    2 +-
 fs/ecryptfs/inode.c                |    4 +-
 fs/ecryptfs/read_write.c           |    4 +-
 fs/udf/super.c                     |    6 ++++
 include/linux/proportions.h        |    4 +++
 kernel/relay.c                     |   10 ++++++-
 mm/filemap_xip.c                   |    7 ++++-
 12 files changed, 78 insertions(+), 22 deletions(-)


