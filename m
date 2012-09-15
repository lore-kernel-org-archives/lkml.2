Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2IOUCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 16:02:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab2IOUCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 16:02:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.6-rc6
Date: Sat, 15 Sep 2012 22:08:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209152208.25990.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.6-rc6

to receive power management fixes for v3.6-rc6 with top-most commit
f25b70613c048ceb1df052576fda03321ebf41cf

  ACPI / PM: Use KERN_DEBUG when no power resources are found

on top of commit 55d512e245bc7699a8800e23df1a24195dd08217

  Linux 3.6-rc5

Included are 3 fixes for ACPI device power management issues we've had for some
time that have been uncovered or started to really annoy people recently.  All
of them are -stable material.

Thanks!


 drivers/acpi/bus.c   | 10 ++++++++++
 drivers/acpi/power.c | 36 ++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 12 deletions(-)

---------------

Aaron Lu (1):
      ACPI / PM: Use KERN_DEBUG when no power resources are found

Lin Ming (1):
      ACPI / PM: Fix resource_lock dead lock in acpi_power_on_device

Rafael J. Wysocki (1):
      ACPI / PM: Infer parent power state from child if unknown, v2

