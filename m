Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1FIVmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:42:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1FIVms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:42:48 -0400
Date: Thu, 9 Jun 2011 23:42:41 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, pefoley2@verizon.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes for 3.0
Message-ID: <20110609214241.GA4849@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the fixes to make sure 3.0 relally is 3.0, plus one fix for
Makefile.asm-generic.  Please pull and unset the SUBLEVEL variable,
thanks.

Michal

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (5):
      kbuild: Fix KERNELVERSION for empty SUBLEVEL or PATCHLEVEL
      kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL
      kbuild: Move depmod call to a separate script
      kbuild: Hack for depmod not handling X.Y versions
      perf: Use make kernelversion instead of parsing the Makefile

Peter Foley (1):
      kbuild: silence Nothing to be done for 'all' message

 Makefile                         |   16 ++----------
 scripts/Makefile.asm-generic     |    1 +
 scripts/depmod.sh                |   48 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/PERF-VERSION-GEN |    7 +----
 4 files changed, 53 insertions(+), 19 deletions(-)
 create mode 100755 scripts/depmod.sh
