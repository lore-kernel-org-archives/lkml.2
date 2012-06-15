Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2FOWmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:42:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51900 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2FOWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:41:59 -0400
Date: Fri, 15 Jun 2012 15:41:58 -0700 (PDT)
Message-Id: <20120615.154158.1041407437357556690.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This just removes some sparc headers that were never, ever, used.

Please pull, thanks a lot!

The following changes since commit 4e3c8a1b1c63482403e9d5e3148dee1a711e4b91:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2012-06-11 16:31:52 +0300)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 8a51178ed64dca418478996697611ef087fa22df:

  sparc: remove two unused headers (2012-06-11 17:05:54 -0700)

----------------------------------------------------------------
Paul Bolle (1):
      sparc: remove two unused headers

 arch/sparc/include/asm/cmt.h    |   59 ----------------------------------------------------
 arch/sparc/include/asm/mpmbox.h |   67 -----------------------------------------------------------
 2 files changed, 126 deletions(-)
 delete mode 100644 arch/sparc/include/asm/cmt.h
 delete mode 100644 arch/sparc/include/asm/mpmbox.h
