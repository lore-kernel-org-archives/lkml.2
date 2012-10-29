Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab2J2Pnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:43:51 -0400
Received: from cobra.newdream.net ([66.33.216.30]:37554 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2Pnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:43:49 -0400
Date: Mon, 29 Oct 2012 08:43:48 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc4
Message-ID: <alpine.DEB.2.00.1210290841250.18873@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are two fixes in the messenger code, one that can trigger a NULL 
dereference, and one that error in refcounting (extra put).  There is also 
a trivial fix that in the fs client code that is triggered by NFS 
reexport.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (1):
      rbd: reset BACKOFF if unable to re-queue

David Zafman (1):
      ceph: fix dentry reference leak in encode_fh()

Sage Weil (1):
      libceph: avoid NULL kref_put when osd reset races with alloc_msg

 fs/ceph/export.c     |    2 ++
 net/ceph/messenger.c |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)
