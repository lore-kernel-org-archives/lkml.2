Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2GSBBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:01:40 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:55623 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2GSBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:01:36 -0400
Subject: [GIT PULL] target fixes for v3.5
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jul 2012 18:01:33 -0700
Message-ID: <1342659693.18004.747.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the last handful of target fixes that have come in recently
that are headed for-3.5 final.  Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes a bugfix from MDR to address a NULL pointer OOPs with FCoE
aborts, along with a WRITE_SAME emulation bugfix for NOLB=0 cases +
persistent reservation return cleanups from Roland.

All three patches are CC'ed to stable.

Thank you!

--nab

Mark Rustad (1):
  tcm_fc: Fix crash seen with aborts and large reads

Roland Dreier (2):
  target: Clean up returning errors in PR handling code
  target: Fix range calculation in WRITE SAME emulation when num blocks
    == 0

 drivers/target/target_core_cdb.c |    2 +-
 drivers/target/target_core_pr.c  |    7 ++++---
 drivers/target/tcm_fc/tfc_cmd.c  |    2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)



