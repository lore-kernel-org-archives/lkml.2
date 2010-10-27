Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0J0Kit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:38:49 -0400
Received: from ozlabs.org ([203.10.76.45]:43368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0J0Kir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:38:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] Minor module changes
Date: Wed, 27 Oct 2010 21:08:43 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010272108.44164.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f9ba5375a8aae4aeea6be15df77e24707a429812:

  Merge branch 'ima-memory-use-fixes' (2010-10-26 11:37:48 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git module

Dzianis Kahanovich (1):
      NULL-terminate all pci_device_id tables

Michał Mirosław (1):
      (trivial) Fix compiler warning in kernel/modules.c

 drivers/dma/pch_dma.c           |    1 +
 drivers/i2c/busses/scx200_acb.c |    3 ++-
 kernel/module.c                 |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)
