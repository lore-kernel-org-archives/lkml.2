Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab2CGWrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026Ab2CGWrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:47:15 -0500
Date: Wed, 7 Mar 2012 22:46:58 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Joe Thornber <thornber@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>, stable@kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: [git pull] device-mapper fixes for 3.3
Message-ID: <20120307224658.GQ16767@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>, stable@kernel.org,
	Jesper Juhl <jj@chaosbits.net>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.3-fixes

to get the following device-mapper fixes for 3.3.

Thanks,
Alasdair

----------------------------------------------------------------
Device-mapper fixes for 3.3.

Eight small device-mapper bug fixes.

----------------------------------------------------------------
Jesper Juhl (1):
      dm ioctl: do not leak argv if target message only contains whitespace

Joe Thornber (2):
      dm thin metadata: unlock superblock in init_pmd error path
      dm thin metadata: decrement counter after removing mapped block

Jonathan E Brassow (2):
      dm raid: set MD_CHANGE_DEVS when rebuilding
      dm raid: fix flush support

Mike Snitzer (2):
      dm flakey: fix crash on read when corrupt_bio_byte not set
      dm thin metadata: remove incorrect close_device on creation error paths

Milan Broz (1):
      dm io: fix discard support

 drivers/md/dm-flakey.c        |    2 +-
 drivers/md/dm-io.c            |   23 ++++++++++++++++-------
 drivers/md/dm-ioctl.c         |    2 +-
 drivers/md/dm-raid.c          |   17 +++++++++++------
 drivers/md/dm-thin-metadata.c |   25 ++++++++++++++++++++-----
 5 files changed, 49 insertions(+), 20 deletions(-)

