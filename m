Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2ALUiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:38:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49959 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2ALUiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:38:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] cleancache improvements for 3.4 (v1).
Date: Thu, 12 Jan 2012 15:36:16 -0500
Message-Id: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F0F44B7.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are some fixes/cleanups that Dan had queued up for some time and
I am posting them for v3.4 review. Here is the hand-off Ack by Dan:
https://lkml.org/lkml/2012/1/12/262

I think you were OK with them, considering most of them have:
'akpm: *says* do this' but since it has been some time I am
reposting them.

If everything looks fine, I can handle the git pull machination so
that you don't have to patch bomb Linus with 300+ patches for v3.4.

These patches are also available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git devel/cleancache.v12

Thanks!


 .../ABI/testing/sysfs-kernel-mm-cleancache         |   11 --
 Documentation/vm/cleancache.txt                    |   41 ++++----
 drivers/staging/zcache/zcache-main.c               |   10 +-
 drivers/xen/tmem.c                                 |   10 +-
 fs/block_dev.c                                     |    2 +-
 fs/super.c                                         |    2 +-
 include/linux/cleancache.h                         |   24 +++---
 mm/cleancache.c                                    |   98 ++++++++------------
 mm/filemap.c                                       |    2 +-
 mm/truncate.c                                      |   10 +-
 10 files changed, 89 insertions(+), 121 deletions(-)

