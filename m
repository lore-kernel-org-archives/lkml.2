Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2APUvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:51:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab2APUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:51:43 -0500
Date: Mon, 16 Jan 2012 21:51:41 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dvhart@linux.intel.com, john.stultz@linaro.org, johnstul@us.ibm.com,
        lacombar@gmail.com, lizf@cn.fujitsu.com, pefoley2@verizon.net,
        udknight@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig for v3.3-rc1
Message-ID: <20120116205141.GA4691@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the kconfig pull request for v3.3-rc1:
* compiler warning fixes
* new merge_config.sh script that some distributions are using
* menuconfig fix for the exit dialog and a fix for the fix

Michal

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

Arnaud Lacombe (1):
      kbuild: Fix compiler warning with assertion when calling 'fwrite'

Darren Hart (2):
      merge_config.sh: use signal names compatible with dash and bash
      merge_config.sh: whitespace cleanup

John Stultz (2):
      kconfig: add merge_config.sh script
      merge_config.sh: fix bug in final check

Li Zefan (1):
      menuconfig: fix a regression when canceling the prompt dialog at exit

Peter Foley (4):
      kconfig: fix warnings by specifing format arguments
      kconfig: fix set but not used warnings
      kconfig: use xfwrite wrapper function to silence warnings
      Improve update-po-config output

Wang YanQing (1):
      menuconfig: let make not report error when not save configuration

 scripts/kconfig/Makefile        |    6 +-
 scripts/kconfig/confdata.c      |    4 +-
 scripts/kconfig/expr.h          |    1 +
 scripts/kconfig/gconf.c         |   11 +--
 scripts/kconfig/lkc.h           |    6 +-
 scripts/kconfig/mconf.c         |    2 +
 scripts/kconfig/merge_config.sh |  117 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 133 insertions(+), 14 deletions(-)
 create mode 100644 scripts/kconfig/merge_config.sh
