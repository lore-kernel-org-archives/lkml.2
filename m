Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2CJOr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 09:47:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:54449 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2CJOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 09:47:24 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] nilfs2 fixes
Date: Sat, 10 Mar 2012 23:35:28 +0900
Message-Id: <1331390130-7286-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.7.4
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Sat, 10 Mar 2012 23:47:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please apply the subsequent two fixes and send them upstream (hopefully
before the next kernel release).  One of them eliminates a reported
kernel oops and the other one fixes an out-of-range issue.

Thank you,

Ryusuke Konishi
--
Haogang Chen (1):
      nilfs2: clamps ns_r_segments_percentage to [1, 99]

Ryusuke Konishi (1):
      nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

 fs/nilfs2/the_nilfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

