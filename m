Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab1DLUPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:15:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41295 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1DLUPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:15:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management Kconfig modifications for 2.6.39
Date: Tue, 12 Apr 2011 22:15:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104122215.28569.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the Kconfig modification introducing CONFIG_HIBERNATE_CALLBACKS and
the Xen patch depending on it from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus


 arch/powerpc/kernel/ibmebus.c |    6 +++---
 arch/x86/xen/Kconfig          |    1 +
 drivers/amba/bus.c            |    6 +++---
 drivers/base/platform.c       |    6 +++---
 drivers/base/power/main.c     |    8 ++++----
 drivers/pci/pci-driver.c      |    6 +++---
 drivers/xen/manage.c          |    6 +++---
 include/linux/suspend.h       |   11 +++--------
 kernel/power/Kconfig          |    6 +++++-
 9 files changed, 28 insertions(+), 28 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM / Hibernate: Introduce CONFIG_HIBERNATE_CALLBACKS

Shriram Rajagopalan (1):
      fix XEN_SAVE_RESTORE Kconfig dependencies
