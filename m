Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1GVIzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:55:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:51553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1GVIzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:55:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,246,1309762800"; 
   d="scan'208";a="31109474"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Jul 2011 11:57:01 +0300
Message-Id: <20110722085701.9716.31764.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes.

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Anatolij Gustschin (1):
      UBIFS: fix master node recovery

Artem Bityutskiy (31):
      UBIFS: return EROFS in case of broken commit
      UBIFS: lessen the size of debugging info data structure
      UBIFS: dump stack when pnode or nnode reading fails
      UBIFS: improve inode dumping function
      UBIFS: rename dbg_check_dir_size function
      UBIFS: minor cleanup: use S_ISREG helper
      UBIFS: remove unnecessary brackets
      UBIFS: remove dead code
      UBIFS: harmonize znode flag helpers
      UBIFS: use correct flags in lprops
      UBIFS: add few commentaries about TNC
      UBIFS: amend debugging name check function prototype
      UBIFS: amend debugging inode size check function prototype
      UBIFS: introduce helper functions for debugging checks and tests
      UBIFS: lessen amount of debugging check types
      UBIFS: switch self-check knobs to debugfs
      UBIFS: be more informative in failure mode
      UBIFS: re-arrange debugging code a bit
      UBIFS: introduce debugfs helpers
      UBIFS: add global debugfs knobs
      UBIFS: remove unused and unneeded debugging function
      UBIFS: always print stacktrace when switching to R/O mode
      UBIFS: introduce more I/O helpers
      UBIFS: switch to ubifs_leb_read
      UBIFS: switch to ubifs_leb_write
      UBIFS: switch to I/O helpers
      UBIFS: stop re-defining UBI operations
      UBIFS: remove custom list of superblocks
      UBIFS: rename recovery testing variables
      UBIFS: improve power cut emulation testing
      MAINTAINERS: change e-mail of Adrian Hunter

 Documentation/filesystems/ubifs.txt |   28 --
 MAINTAINERS                         |    3 +-
 fs/ubifs/commit.c                   |    8 +-
 fs/ubifs/debug.c                    |  762 +++++++++++++++++++++++------------
 fs/ubifs/debug.h                    |  241 ++++++-----
 fs/ubifs/dir.c                      |   16 +-
 fs/ubifs/file.c                     |    2 +-
 fs/ubifs/io.c                       |  168 ++++++--
 fs/ubifs/log.c                      |    6 +-
 fs/ubifs/lprops.c                   |    8 +-
 fs/ubifs/lpt.c                      |   37 +-
 fs/ubifs/lpt_commit.c               |   40 +-
 fs/ubifs/misc.h                     |  103 +----
 fs/ubifs/orphan.c                   |    2 +-
 fs/ubifs/recovery.c                 |   43 +-
 fs/ubifs/replay.c                   |    3 +-
 fs/ubifs/sb.c                       |    6 +-
 fs/ubifs/scan.c                     |    4 +-
 fs/ubifs/super.c                    |    6 +-
 fs/ubifs/tnc.c                      |   26 +-
 fs/ubifs/tnc_commit.c               |  145 +++----
 fs/ubifs/ubifs.h                    |   21 +-
 22 files changed, 978 insertions(+), 700 deletions(-)

Thanks,
Artem.
