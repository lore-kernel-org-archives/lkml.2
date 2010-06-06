Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0FFPPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:15:24 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38493 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0FFPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:15:22 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Cc: Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 0/7] Add some checks to be used with Coccinelle
Date: Sun,  6 Jun 2010 17:15:00 +0200
Message-Id: <1275837307-4283-1-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a front-end to use Coccinelle.  It also
includes a documentation file describing how to use the new
'coccicheck' target. Finally, some SmPL examples are provided.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>

Nicolas Palix (7):
  Add a target to use the Coccinelle checker
  Add Documentation/coccinelle.txt
  Add scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
  Add scripts/coccinelle/alloc/kzalloc-simple.cocci
  Add scripts/coccinelle/resource_size.cocci
  Add scripts/coccinelle/err_cast.cocci
  Add scripts/coccinelle/deref_null.cocci

 Documentation/coccinelle.txt                     |  258 +++++++++++++++++++
 MAINTAINERS                                      |   10 +
 Makefile                                         |   10 +-
 scripts/Makefile.help                            |    3 +
 scripts/coccicheck                               |   54 ++++
 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci |   67 +++++
 scripts/coccinelle/alloc/kzalloc-simple.cocci    |   82 ++++++
 scripts/coccinelle/deref_null.cocci              |  293 ++++++++++++++++++++++
 scripts/coccinelle/err_cast.cocci                |   56 ++++
 scripts/coccinelle/resource_size.cocci           |   93 +++++++
 10 files changed, 923 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/coccinelle.txt
 create mode 100644 scripts/Makefile.help
 create mode 100755 scripts/coccicheck
 create mode 100644 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
 create mode 100644 scripts/coccinelle/alloc/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/deref_null.cocci
 create mode 100644 scripts/coccinelle/err_cast.cocci
 create mode 100644 scripts/coccinelle/resource_size.cocci

