Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1AXEIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:08:04 -0500
Received: from ozlabs.org ([203.10.76.45]:57775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1AXEID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:08:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module and param
Date: Mon, 24 Jan 2011 14:37:50 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241437.51173.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Dmitry Torokhov (1):
      module: show version information for built-in modules in sysfs

Linus Walleij (1):
      param: add null statement to compiled-in module params

Rusty Russell (2):
      module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n
      module: fix missing semicolons in MODULE macro usage

 drivers/net/arm/ks8695net.c       |    2 +-
 include/asm-generic/vmlinux.lds.h |    7 ++++
 include/linux/module.h            |   27 +++++++++++++++
 include/linux/moduleparam.h       |    6 ++-
 kernel/params.c                   |   65 ++++++++++++++++++++++++++++++------
 net/dsa/dsa.c                     |    2 +-
 6 files changed, 94 insertions(+), 15 deletions(-)
