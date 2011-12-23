Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1LWWL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:11:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab1LWWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:11:32 -0500
Date: Fri, 23 Dec 2011 17:11:12 -0500 (EST)
Message-Id: <20111223.171112.806046844903961542.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 23 Dec 2011 14:11:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this PCI MSI initialization bug fix.

Thanks!

The following changes since commit b3b1b70e62a603f473619dbebc3b3d23f535e6f8:

  Merge branch 'usb-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2011-12-22 12:59:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc64: Fix MSIQ HV call ordering in pci_sun4v_msiq_build_irq().

 arch/sparc/kernel/pci_sun4v.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
