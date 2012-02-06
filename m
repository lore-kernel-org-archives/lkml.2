Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2BFMoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:44:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39971 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2BFMoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:44:04 -0500
X-AuditID: b753bd60-9aa63ba00000359c-82-4f2fcb10f946
X-AuditID: b753bd60-9aa63ba00000359c-82-4f2fcb10f946
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 0/3] xfs: change available ranges in quota check
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 06 Feb 2012 21:49:51 +0900
Message-ID: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series changes available ranges of softlimit and
hardlimit in quota check. Currently xfs quota allows us to
use disk blocks up to lower than quota limits. They should
be used up to not beyond them.

Thanks.

---

Mitsuo Hayasaka (3):
      xfs: cleanup quota check on disk blocks and inodes reservations
      xfs: make inode quota check more general
      xfs: change available ranges of softlimit and hardlimit in quota check


 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   15 +++++++--------
 4 files changed, 24 insertions(+), 25 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
