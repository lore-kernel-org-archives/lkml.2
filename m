Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2CKOUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 10:20:21 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:49091 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2CKOUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 10:20:21 -0400
Subject: [PATCH 0/2] NFS: blocklayout PipeFS conteinerization fixes 
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Sun, 11 Mar 2012 18:20:13 +0400
Message-ID: <20120311141528.17962.83828.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set moves global wait queue and message to per-net data structure.

---

Stanislav Kinsbursky (2):
      NFS: replace global bl_mount_reply with per-net one
      NFS: replace global bl_wq with per-net one


 fs/nfs/blocklayout/blocklayout.c    |    4 +--
 fs/nfs/blocklayout/blocklayout.h    |    8 +++----
 fs/nfs/blocklayout/blocklayoutdev.c |   41 ++++++++++++++++++++---------------
 fs/nfs/blocklayout/blocklayoutdm.c  |   26 ++++++++++++----------
 fs/nfs/netns.h                      |    7 ++++++
 5 files changed, 48 insertions(+), 38 deletions(-)

