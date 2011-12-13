Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1LMQWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:22:42 -0500
Received: from sh.osrg.net ([192.16.179.4]:57455 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab1LMQWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:22:37 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/2] nilfs2 bug fixes
Date: Wed, 14 Dec 2011 01:13:47 +0900
Message-Id: <1323792829-17395-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.7.4
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 14 Dec 2011 01:22:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Would you please send the subsequent two fixes upstream via your tree?

My nilfs tree on kernel.org is still dead, and I would appreciate it
if you mediate patches during the period until the nilfs tree comes
back.


One of these patches fixes an interger overflow issue, and another
fixes defect of nilfs2 compat ioctl which makes snapshot operations
and garbage collection inoperable on heterogeneous environment such
like machines with 32-bit userland and 64-bit kernel.

I hope these will be applied before the next kernel release.

Thanks in advance,
Ryusuke Konishi
--

Haogang Chen (1):
      nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()

Thomas Meyer (1):
      nilfs2: unbreak compat ioctl

 fs/nilfs2/ioctl.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

