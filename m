Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0LaNuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 08:50:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0LaNuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 08:50:13 -0500
Date: Fri, 31 Dec 2010 14:50:11 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: JBeulich@novell.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kconfig fix for 2.6.37
Message-ID: <20101231135011.GA22046@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there is a fix for a minor regression introduced by the new "visible"
kconfig keyword. The problem is that entries marked as "invisible" are
written out to .config and during make all{mod,yes}config are even set
(although the user cannot set them manually). The fix makes it
consistent again, i.e. invisible entries are not set by make
all{mod,yes}config and are not saved to .config. The issue is really
minor, so if you don't want to merge it now, I'll send the pull request
again for 2.6.38-rc1.

Michal

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Jan Beulich (1):
      kconfig: fix undesirable side effect of adding "visible" menu attribute

 scripts/kconfig/menu.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
