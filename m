Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641Ab2EPUKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:10:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6058 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608Ab2EPUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:10:37 -0400
Message-ID: <4FB409BB.8030800@tilera.com>
Date: Wed, 16 May 2012 16:10:35 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile tree bug fixes for v3.4
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.4 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

These are both bug-fixes, one to avoid some issues in how we invoke the
"pending userspace work" flags on return to userspace, and the other to
provide the same signal handler arguments for tilegx32 that we do for tilegx64.

Chris Metcalf (2):
      arch/tile: fix up some issues in calling do_work_pending()
      arch/tile: apply commit 74fca9da0 to the compat signal handling as well

 arch/tile/include/asm/thread_info.h |    9 ++++++-
 arch/tile/kernel/compat_signal.c    |   12 ++++------
 arch/tile/kernel/intvec_32.S        |   41 +++++++++++++++++++++++-----------
 arch/tile/kernel/intvec_64.S        |   38 +++++++++++++++++++++++--------
 arch/tile/kernel/process.c          |    7 ++++-
 5 files changed, 73 insertions(+), 34 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

