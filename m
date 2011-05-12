Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1ELBWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:22:08 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54281 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1ELBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=zD7Fa4qTUM4nhn/o3PFJ3dU/KaKR4sU7ckSXQNPiFrx3xAeu
	GJ0oMqIa0pk64gHeCuo/yCR5hjiomlXDMzMNOw/SGCcJkPBxeO4HpB+4/VF3UhQm
	dlrPvPXY8mBFIhrIYN3+Y4gWZlLEdtFNbng5sagabQMAVnwVbcIzO9X4kuo=
Date: Wed, 11 May 2011 18:22:55 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.39
Message-ID: <Pine.LNX.4.64.1105111821080.14296@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bug fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These patches came in pretty late but fix a few crashes and deadlocks that 
turned up under blogbench.

Thanks!
sage


Henry C Chang (3):
      ceph: print debug message before put mds session
      ceph: fix list_add in ceph_put_snap_realm
      ceph: do not use i_wrbuffer_ref as refcount for Fb cap

 fs/ceph/caps.c       |   16 ++++++++--------
 fs/ceph/inode.c      |    1 +
 fs/ceph/mds_client.c |    2 +-
 fs/ceph/snap.c       |    2 +-
 fs/ceph/super.h      |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)
