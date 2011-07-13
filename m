Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339Ab1GMLcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:32:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915Ab1GMLce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:32:34 -0400
Date: Wed, 13 Jul 2011 13:32:32 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild depmod fix
Message-ID: <20110713113232.GA12386@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the fix for depmod.sh to use /tmp rather than the builddir.

Michal

The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (1):
      kbuild: Do not write to builddir in modules_install

 scripts/depmod.sh |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)
