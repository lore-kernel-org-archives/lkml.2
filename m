Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2DGCY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:24:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33266 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2DGCYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:24:18 -0400
Subject: [GIT PULL] target fixes for v3.4-rc2
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        openfcoe-devel <devel@open-fcoe.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 19:24:15 -0700
Message-ID: <1333765455.23396.154.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please go ahead and pull the following tcm_fc fabric related fixes for
-rc2 here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.4-rc-fixes

This branch is based upon the following mainline HEAD:

commit dd775ae2549217d3ae09363e3edb305d0fa19928
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Mar 31 16:24:09 2012 -0700

    Linux 3.4-rc1

Note that both have been CC'ed to stable, and patch #1 is the important
one that addresses a memory corruption bug related to FC exchange
timeouts + command abort.

Thanks again to MDR for tracking down this issue!

--nab

Mark Rustad (2):
  tcm_fc: Add abort flag for gracefully handling exchange timeout
  tcm_fc: Do not free tpg structure during wq allocation failure

 drivers/target/tcm_fc/tcm_fc.h   |    1 +
 drivers/target/tcm_fc/tfc_cmd.c  |   10 ++++++++--
 drivers/target/tcm_fc/tfc_conf.c |   13 ++++++++-----
 drivers/target/tcm_fc/tfc_io.c   |    2 ++
 4 files changed, 19 insertions(+), 7 deletions(-)


