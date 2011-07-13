Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1GMWDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:03:48 -0400
Received: from void.printf.net ([89.145.121.20]:56147 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab1GMWDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:03:47 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fix for 3.0.
Date: Wed, 13 Jul 2011 18:03:40 -0400
Message-ID: <m239i9vnwj.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive a tested MMC regression fix against 3.0-rc1.  Thanks.


The following changes since commit 8d86e5f91440aa56a5df516bf58fe3883552ad56:

  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2011-07-12 14:21:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Philip Rakity (1):
      mmc: core: Bus width testing needs to handle suspend/resume

 drivers/mmc/core/mmc.c   |   75 ++++++++++++++++++++++++++++++----------------
 include/linux/mmc/card.h |   13 ++++++++
 2 files changed, 62 insertions(+), 26 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
