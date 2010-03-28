Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0C1C3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 22:29:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36749
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab0C1C3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 22:29:05 -0400
Date: Sat, 27 Mar 2010 19:29:29 -0700 (PDT)
Message-Id: <20100327.192929.35046895.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this revert which should fix regressions
reported by users with VIA IDE chips.

Thanks!

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

David S. Miller (1):
      Revert "via82cxxx: workaround h/w bugs"

 drivers/ide/via82cxxx.c |   57 -----------------------------------------------
 1 files changed, 0 insertions(+), 57 deletions(-)

