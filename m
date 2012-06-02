Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965891Ab2FBWXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 18:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2FBWXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 18:23:15 -0400
Date: Sat, 2 Jun 2012 23:22:54 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [git pull] device-mapper updates for 3.5
Message-ID: <20120602222254.GI20415@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>, Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Christie <michaelc@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-changes
 
to get the following device-mapper updates for 3.5.
 
Thanks,
Alasdair

----------------------------------------------------------------
Improve multipath's retrying mechanism in some defined circumstances
and provide a simple reserve/release mechanism for userspace tools to
access thin provisioning metadata while the pool is in use.

----------------------------------------------------------------
Joe Thornber (1):
      dm thin: provide userspace access to pool metadata

Mike Christie (1):
      dm mpath: delay retry of bypassed pg

Mike Snitzer (2):
      dm mpath: reduce size of struct multipath
      dm thin: use slab mempools

Mikulas Patocka (1):
      dm mpath: allow ioctls to trigger pg init

 Documentation/device-mapper/thin-provisioning.txt |   11 ++
 drivers/md/dm-mpath.c                             |   47 +++--
 drivers/md/dm-thin-metadata.c                     |  136 +++++++++++++-
 drivers/md/dm-thin-metadata.h                     |   13 +-
 drivers/md/dm-thin.c                              |  203 ++++++++++++++-------
 5 files changed, 320 insertions(+), 90 deletions(-)
