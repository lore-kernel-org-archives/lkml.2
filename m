Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1CRTx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:53:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1CRTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:53:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fix for 2.6.39
Date: Fri, 18 Mar 2011 20:53:56 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103182053.56986.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management fix for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This patch should have gone before commit 9659cc0678b954f187290c6e8b247a673c5d37e1
(PM: Make system-wide PM and runtime PM treat subsystems consistently), because
without the changes made by it this commit introduces a suspend regression.
Unfortunately, it was missing from my for-2.6.39 queue and didn't make it to
the previous pull request.  Sorry about that.


 drivers/usb/core/driver.c |   15 +++------------
 drivers/usb/core/usb.c    |    5 +++++
 drivers/usb/core/usb.h    |    3 +++
 3 files changed, 11 insertions(+), 12 deletions(-)

---------------

Rafael J. Wysocki (1):
      USB: Move runtime PM callbacks to usb_device_pm_ops

