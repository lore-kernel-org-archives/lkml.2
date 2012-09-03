Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2ICOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:14:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2ICOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:14:22 -0400
From: yan <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Trivial code clean for procfs
Date: Mon,  3 Sep 2012 22:14:04 +0800
Message-Id: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


yan (3):
  proc: return -ENOMEM when inode allocation failed
  proc: no need to initialize proc_inode->fd in proc_get_inode
  proc: use kzalloc instead of kmalloc and memset

 fs/proc/generic.c |    5 ++---
 fs/proc/inode.c   |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
1.7.9.5

