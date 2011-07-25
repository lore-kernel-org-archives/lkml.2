Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1GYXck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:32:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1GYXce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:32:34 -0400
Date: Tue, 26 Jul 2011 01:32:32 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mfm@muteddisk.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild packaging fix for 3.1-rc1
Message-ID: <20110725233232.GA1120@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this fix for make perf-*-pkg.

Thanks,
Michal

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

matt mooney (1):
      package: Makefile: fix perf target bug

 scripts/package/Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)
