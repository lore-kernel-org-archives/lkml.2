Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2ELBHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 21:07:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab2ELBHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 21:07:43 -0400
Date: Sat, 12 May 2012 02:07:34 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Ben Marzinski <bmarzins@redhat.com>,
        linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Joe Thornber <thornber@redhat.com>,
        stable@kernel.org, xiaoli@redhat.com
Subject: [git pull] device-mapper fixes for 3.4
Message-ID: <20120512010734.GA20415@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, Ben Marzinski <bmarzins@redhat.com>,
	linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Joe Thornber <thornber@redhat.com>,
	stable@kernel.org, xiaoli@redhat.com
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

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.4-fixes

to get the following device-mapper fixes for 3.4.

Thanks,
Alasdair

----------------------------------------------------------------
Device-mapper fixes for 3.4.

Fix a couple of serious memory leaks in device-mapper thin provisioning
and tidy its MODULE_DESCRIPTION.

Mitigate occasional reported hangs associated with multipath scsi_dh
module loading.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm thin: correct module description

Mike Snitzer (3):
      dm thin: reinstate missing mempool_free in cell_release_singleton
      dm thin: fix unprotected use of prepared_discards list
      dm mpath: check if scsi_dh module already loaded before trying to load

 drivers/md/dm-mpath.c |    4 ++--
 drivers/md/dm-thin.c  |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)
