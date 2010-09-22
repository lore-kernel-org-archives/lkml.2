Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0IVSKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:10:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42448
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab0IVSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:10:00 -0400
Date: Wed, 22 Sep 2010 11:10:19 -0700 (PDT)
Message-Id: <20100922.111019.200357319.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro has been auditing signal handling in various architectures,
and he found some sparc bugs along the way.

Those he found are fixed here, as well as a short patch to add
raw perf event support.

Please pull, thanks a lot!

The following changes since commit 2422084a94fcd5038406261b331672a13c92c050:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6 (2010-09-19 11:09:23 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc64: Support RAW perf events.
      sparc64: Fix race in signal instruction flushing.
      sparc: Don't mask signal when we can't setup signal frame.
      sparc: Prevent no-handler signal syscall restart recursion.

 arch/sparc/kernel/perf_event.c |   14 +++-
 arch/sparc/kernel/signal32.c   |  161 ++++++++++++++++++++++++----------------
 arch/sparc/kernel/signal_32.c  |   55 +++++++++-----
 arch/sparc/kernel/signal_64.c  |   45 +++++++----
 4 files changed, 171 insertions(+), 104 deletions(-)
