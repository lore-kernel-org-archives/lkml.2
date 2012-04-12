Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab2DLDix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 23:38:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:50949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab2DLDik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 23:38:40 -0400
Message-ID: <1334201907.2984.70.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 12 Apr 2012 13:38:27 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are fixes for two nasty regression affecting powerpc in 3.4.

Please apply,

Cheers,
Ben.

The following changes since commit b1a808ff436343956a6ae63178ea1810c5e5a3a1:

  Merge branch 'for-next' of git://gitorious.org/kernel-hsi/kernel-hsi (2012-04-02 09:50:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to fae2e0fb24c61ca68c98d854a34732549ebc1854:

  powerpc: Fix typo in runlatch code (2012-04-11 10:42:15 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (2):
      powerpc: Fix page fault with lockdep regression
      powerpc: Fix typo in runlatch code

 arch/powerpc/kernel/entry_32.S |   39 +++++++++++++++++++++------------------
 arch/powerpc/kernel/process.c  |    4 ++--
 2 files changed, 23 insertions(+), 20 deletions(-)


