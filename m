Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2GCNxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GCNxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:53:17 -0400
Date: Tue, 3 Jul 2012 14:53:10 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        stable@vger.kernel.org, Milan Broz <mbroz@redhat.com>
Subject: [git pull] device-mapper fixes for 3.5
Message-ID: <20120703135310.GT20415@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	stable@vger.kernel.org, Milan Broz <mbroz@redhat.com>
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
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-fixes

to get the following device-mapper fixes for 3.5.
 
Thanks,
Alasdair
 
----------------------------------------------------------------
Four minor thin provisioning fixes and correct and update dm-verity
documentation.

----------------------------------------------------------------
Joe Thornber (1):
      dm thin: commit metadata before creating metadata snapshot

Mike Snitzer (3):
      dm persistent data: fix shadow_info_leak on dm_tm_destroy
      dm persistent data: handle space map checker creation failure
      dm persistent data: fix allocation failure in space map checker init

Milan Broz (1):
      dm: verity fix documentation

 Documentation/device-mapper/verity.txt             |  131 +++++++-------------
 drivers/md/dm-thin.c                               |    7 ++
 drivers/md/persistent-data/dm-space-map-checker.c  |   54 ++++----
 drivers/md/persistent-data/dm-space-map-disk.c     |   11 +-
 .../md/persistent-data/dm-transaction-manager.c    |   11 +-
 5 files changed, 103 insertions(+), 111 deletions(-)
