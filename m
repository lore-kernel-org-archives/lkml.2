Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2APTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:25:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab2APTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:25:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes and additional updates for 3.3
Date: Mon, 16 Jan 2012 20:28:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201162028.52945.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes and additional updates (on top of commit
96e80a7851b44f3decaac0625665cd64e550b71d) for 3.3 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-linus

with top-most commit ee34a37049114303011e154478c63b977bcff24c
(PM / Hibernate: Drop the check of swap space size for compressed image).

They include:

* Build fixes for generic PM domains.

* A3SP power domain suspend fix from Guennadi Liakhovetski.

* Fix for a regression that made sysrq-o unavailable for CONFIG_PM unset.

* Hibernate modification dropping swap size check for compressed images.

Thanks!


 arch/arm/mach-shmobile/pm-sh7372.c   |    2 +-
 drivers/base/power/domain.c          |   15 +++++++++++++++
 drivers/base/power/domain_governor.c |   24 +++++++++++++++++++-----
 kernel/Makefile                      |    3 +--
 kernel/power/swap.c                  |   13 +++++++------
 5 files changed, 43 insertions(+), 14 deletions(-)

---------------

Barry Song (1):
      PM / Hibernate: Drop the check of swap space size for compressed image

Guennadi Liakhovetski (1):
      PM / shmobile: fix A3SP suspend method

Rafael J. Wysocki (3):
      PM: Make sysrq-o be available for CONFIG_PM unset
      PM / Domains: Fix build for CONFIG_PM_SLEEP unset
      PM / Domains: Skip governor functions for CONFIG_PM_RUNTIME unset

