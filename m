Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2FCTjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:39:45 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:53377 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2FCTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:39:43 -0400
Subject: [GIT PULL] target 3.5-merge fixes for -rc2
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Christoph Hellwig <hch@lst.de>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jun 2012 12:39:32 -0700
Message-ID: <1338752372.4238.24.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are two target patches currently in the queue for 3.5-rc2.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.5-merge-fixes

The first is a small name-space collision fix from Stefan for the new
sbp-target / ieee-1394 code, and second is the FILEIO backend conversion
patch to always use O_DSYNC by default instead of O_SYNC as recommended
by hch.  Note the latter is CC'ed stable.

This branch is based upon commit:

commit af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76
Merge: 65a50c9 6bd9adb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 30 11:17:19 2012 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client

Please let us know if you have any concerns.

Thanks!

--nab

Nicholas Bellinger (1):
  target/file: Use O_DSYNC by default for FILEIO backends

Stefan Richter (1):
  sbp-target: rename a variable to avoid name clash

 drivers/target/sbp/sbp_target.c   |    8 ++--
 drivers/target/target_core_file.c |   70 +++++++++----------------------------
 drivers/target/target_core_file.h |    1 -
 3 files changed, 21 insertions(+), 58 deletions(-)

