Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab0CPVqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:46:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46177
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab0CPVqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:46:16 -0400
Date: Tue, 16 Mar 2010 14:46:37 -0700 (PDT)
Message-Id: <20100316.144637.223372881.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix sunxvr1000 depenencies.

Fix register bit macro used to set interrupt mask in sunsab driver,
from Julia Lawall.

Add MAINTAINERS entry for Sun serial drivers.

Please pull, thanks a lot!

The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      MAINTAINERS: Add entry for sparc serial drivers.
      sunxvr1000: Add missing FB=y depenency.

Julia Lawall (1):
      drivers/serial/sunsab.c: adjust the constant used to initialize the interrupt_mask0 fields

 MAINTAINERS             |   15 +++++++++++++++
 drivers/serial/sunsab.c |    2 +-
 drivers/video/Kconfig   |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)
