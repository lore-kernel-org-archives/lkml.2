Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2G0E07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:26:59 -0400
Received: from ozlabs.org ([203.10.76.45]:48546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab2G0E06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:26:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PULL] trivial comment changes, init and cpumask.
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 27 Jul 2012 09:34:18 +0930
Message-ID: <87ehnynk71.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git tags/cpumask-for-linus

for you to fetch changes up to 231daf0751ccaf21373f591c524a3f557a15d03f:

  cpumask: cpulist_parse() comments correction (2012-07-27 09:29:42 +0930)

----------------------------------------------------------------
Trivial comment changes to cpumask code.  I guess it's getting boring.

----------------------------------------------------------------
Alex Shi (2):
      cpumask: add a few comments of cpumask functions
      cpumask: cpulist_parse() comments correction

Jim Cromie (1):
      init: add comments to keep initcall-names in sync with initcall levels

 include/linux/cpumask.h |   15 +++++++++++++--
 include/linux/init.h    |    3 ++-
 init/main.c             |    1 +
 3 files changed, 16 insertions(+), 3 deletions(-)
