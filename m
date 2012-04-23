Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2DWStW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:49:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab2DWStV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:49:21 -0400
Date: Mon, 23 Apr 2012 20:49:18 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] modpost fix for newer toolchain
Message-ID: <20120423184918.GA27862@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this modpost patch. It fixes build failure with newer gcc that adds
some internal symbols that end in "__mod_*_device_table", but are not
actually the tables themselves.

Michal

The following changes since commit 0eb043d0eec44cd083ea6910b1db2f77eb212ebd:

  Subject: [PATCH] tags.sh: Add missing quotes (2012-04-02 11:28:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to e88aa7bbbe3046a125ea1936b16bb921cc9c6349:

  Fix modpost failures in fedora 17 (2012-04-18 21:42:07 +0200)

----------------------------------------------------------------
David Miller (1):
      Fix modpost failures in fedora 17

 scripts/mod/file2alias.c |    4 ++++
 1 file changed, 4 insertions(+)
