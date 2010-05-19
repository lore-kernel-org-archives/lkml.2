Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0ESIKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:10:15 -0400
Received: from ozlabs.org ([203.10.76.45]:55167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0ESIKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:10:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] modules
Date: Wed, 19 May 2010 17:39:43 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Brandon Philips <brandon@ifup.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005191739.44524.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 537b60d17894b7c19a6060feae40299d7109d6e7:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git modules

Ondrej Zary (1):
      MODULE_DEVICE_TABLE(isapnp, ...) does nothing

Rusty Russell (3):
      isapnp: move definitions to mod_devicetable.h so file2alias can reach them.
      hisax_fcpcipnp: fix broken isapnp device table.
      module: drop the lock while waiting for module to complete initialization.

 drivers/isdn/hisax/hisax_fcpcipnp.c |    3 +-
 include/linux/isapnp.h              |    8 +----
 include/linux/mod_devicetable.h     |    7 ++++
 kernel/module.c                     |   57 ++++++++++++++++++++++-------------
 scripts/mod/file2alias.c            |   17 ++++++++++
 5 files changed, 63 insertions(+), 29 deletions(-)
