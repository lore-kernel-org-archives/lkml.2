Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2DFABJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2DFABG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:01:06 -0400
Date: Thu, 5 Apr 2012 17:01:05 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] APM
Message-ID: <alpine.LNX.2.00.1204051649380.9041@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git for-linus

to receive one deadlock/race fix from Niel that got introduced when
we were moving away from freezer_*_count() to wait_event_freezable().

Thanks.

NeilBrown (1):
      APM: fix deadlock in APM_IOC_SUSPEND ioctl

 drivers/char/apm-emulation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs
