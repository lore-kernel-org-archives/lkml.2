Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1KRUqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:46:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37435 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1KRUqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:46:11 -0500
Date: Fri, 18 Nov 2011 14:46:27 -0600
From: Ben Myers <bpm@sgi.com>
To: torvalds@linux-foundation.org
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] XFS update for 3.2-rc3
Message-ID: <20111118204627.GQ749@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following changes for XFS for 3.2-rc3.  

One is a bugfix for a regression related to quotas, and the other adds
me to the MAINTAINERS list for XFS.

Thanks much!
-Ben

The following changes since commit b6844523839779030430ff28f036f83e2a3f43e6:
  Linus Torvalds (1):
        Merge branch 'stable/for-linus-fixes-3.2' of git://git.kernel.org/.../konrad/xen

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      MAINTAINERS: update XFS maintainer entry

Mitsuo Hayasaka (1):
      xfs: use doalloc flag in xfs_qm_dqattach_one()

 MAINTAINERS     |    3 ++-
 fs/xfs/xfs_qm.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)
