Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2GTO2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2GTO22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:28:28 -0400
Date: Fri, 20 Jul 2012 15:28:21 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] Further device-mapper fixes for 3.5
Message-ID: <20120720142821.GC20415@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
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
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-fixes-2

to get the following further device-mapper fixes for 3.5.
 
Thanks,
Alasdair
  
----------------------------------------------------------------
Three fixes for device-mapper discard processing:
  - avoid a crash in dm-raid1 when discards coincide with mirror recovery;
  - avoid discarding shared data that's still needed in dm-thin;
  - don't guarantee that discarded blocks will be wiped in dm-raid1.

----------------------------------------------------------------
Mikulas Patocka (3):
      dm raid1: fix crash with mirror recovery and discard
      dm thin: do not send discards to shared blocks
      dm raid1: set discard_zeroes_data_unsupported

 drivers/md/dm-raid1.c       |    3 ++-
 drivers/md/dm-region-hash.c |    5 ++++-
 drivers/md/dm-thin.c        |    6 +++++-
 3 files changed, 11 insertions(+), 3 deletions(-)
