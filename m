Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1H2Quz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:50:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab1H2Quw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:50:52 -0400
Date: Mon, 29 Aug 2011 12:50:20 -0400 (EDT)
Message-Id: <20110829.125020.877556014112084807.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 09:50:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc64 build fix and a sparc32 fix for
IRQ cross-calls.

Thanks!

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

Kjetil Oftedal (1):
      sparc32,sun4d: Change IPI IRQ level to prevent collision between IPI and timer interrupt

Stephen Rothwell (1):
      sparc: Remove another reference to nfsservctl

 arch/sparc/kernel/irq.h        |    2 +-
 arch/sparc/kernel/systbls_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
