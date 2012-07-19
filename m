Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2GSWdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:33:51 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38031 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2GSWdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:33:49 -0400
Date: Thu, 19 Jul 2012 15:33:48 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.5
Message-ID: <alpine.DEB.2.00.1207191451090.24473@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these last minute fixes for Ceph from:

 git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The important one fixes a bug in the socket failure handling behavior that 
was turned up in some recent failure injection testing.  The other two are 
minor bug fixes.

Thanks!
sage

----------------------------------------------------------------
Dan Carpenter (1):
      rbd: endian bug in rbd_req_cb()

Sage Weil (1):
      libceph: fix messenger retry

Yan, Zheng (1):
      rbd: Fix ceph_snap_context size calculation

 drivers/block/rbd.c            |    4 ++--
 include/linux/ceph/messenger.h |   12 ++----------
 net/ceph/messenger.c           |   12 ++++++------
 3 files changed, 10 insertions(+), 18 deletions(-)
