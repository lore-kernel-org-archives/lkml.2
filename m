Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2G3JtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:49:20 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:47024 "EHLO linux.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752321Ab2G3JtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:49:19 -0400
Date: Mon, 30 Jul 2012 11:49:16 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fix for v3.6-rc1
Message-ID: <20120730094916.GA65043@noe.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the main kbuild branch ended up with a single commit this time, a fix to
send errors to stderr. Please pull from the below repository.

Thanks,
Michal

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Michal Marek (1):
      kbuild: Print errors to stderr

 Makefile                |   24 ++++++++++++------------
 scripts/link-vmlinux.sh |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)
