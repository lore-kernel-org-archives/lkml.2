Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2LMULg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:11:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2LMULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:11:35 -0500
Date: Thu, 13 Dec 2012 15:11:33 -0500 (EST)
Message-Id: <20121213.151133.2012383937905504753.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not much going on this release cycle in sparc land, just a Kconfig
tweak.

Please pull, thanks a lot!

The following changes since commit 1afa471706963643ceeda7cbbe9c605a1e883d53:

  Merge tag 'mmc-fixes-for-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2012-12-07 09:15:20 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 476ab8fb78105f525cc56babb3980ffdd916aa24:

  of_i2c: sparc: Allow OF_I2C for sparc (2012-12-07 09:17:55 -0800)

----------------------------------------------------------------
Andreas Larsson (1):
      of_i2c: sparc: Allow OF_I2C for sparc

 drivers/of/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
