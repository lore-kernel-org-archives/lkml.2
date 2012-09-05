Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2IEMRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:17:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61780 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IEMRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:17:34 -0400
From: yan <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v2] Trivial code clean for procfs
Date: Wed,  5 Sep 2012 20:17:14 +0800
Message-Id: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from v1 :
	Add detailed changelog (suggested by Andrew Morton)

yan (3):
  proc: return -ENOMEM when inode allocation failed
  proc: no need to initialize proc_inode->fd in proc_get_inode
  proc: use kzalloc instead of kmalloc and memset

 fs/proc/generic.c |    5 ++---
 fs/proc/inode.c   |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
1.7.9.5

