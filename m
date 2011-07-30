Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1G3TY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:24:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1G3TYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:24:21 -0400
Date: Sat, 30 Jul 2011 21:24:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1107302120140.7300@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from for-linus branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive the fix below. It fixes a compilation failure introduced by 
tree-wide duplicate include removal (caused by overlooking that one 
particular include is in ifdefed section, making the removal 
non-equivalent change).

Thanks.

Jiri Kosina (1):
      sungem: fix compile failure caused by trivial #include consolidation

 drivers/net/sungem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Jiri Kosina
SUSE Labs

