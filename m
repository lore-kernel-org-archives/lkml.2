Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab1D0Uqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:46:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954Ab1D0Uqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:46:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management regression fixes for 2.6.39
Date: Wed, 27 Apr 2011 22:47:07 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Len Brown <lenb@kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104272247.07545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two power management regression fixes for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

The first one fixes device initialization so that wakeup-related files are
created for all wakeup-capable devices as appropriate and the other is a
workaround for some BIOS brain damage that started to be visible and hurt
people after recent changes in the handling of ACPI power resources.
 

 drivers/acpi/scan.c         |    4 ++++
 drivers/base/power/main.c   |    1 +
 drivers/base/power/wakeup.c |    2 +-
 3 files changed, 6 insertions(+), 1 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM / Wakeup: Fix initialization of wakeup-related device sysfs files
      ACPI / PM: Avoid infinite recurrence while registering power resources

