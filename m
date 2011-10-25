Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1JYJXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:23:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1JYJXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:23:33 -0400
Date: Tue, 25 Oct 2011 11:23:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] APM
Message-ID: <alpine.LNX.2.00.1110251014210.3541@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git for-linus

to receive update to legacy APM code.

Thanks.

Tejun Heo (1):
      apm-emulation: use wait_event_freezable() instead of freezer_[do_not_]count()

 drivers/char/apm-emulation.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

-- 
Jiri Kosina
SUSE Labs

