Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2IXC6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:58:33 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36970 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2IXC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:58:32 -0400
Date: Sun, 23 Sep 2012 19:58:31 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.6
Message-ID: <alpine.DEB.2.00.1209231956000.11925@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes for Ceph from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The first fixes a leak in the rbd setup error path, and the second fixes a 
more serious problem with mismatched kmap/kunmap that surfaced after the 
recent refactoring work.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (2):
      rbd: drop dev reference on error in rbd_open()
      libceph: only kunmap kmapped pages

 drivers/block/rbd.c  |    7 +++----
 net/ceph/messenger.c |    5 +----
 2 files changed, 4 insertions(+), 8 deletions(-)
