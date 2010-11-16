Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0KPXMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:12:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab0KPXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:12:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More power management fixes for 2.6.37
Date: Wed, 17 Nov 2010 00:11:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170011.46080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a few more power management fixes for 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They include:

* Fix for an embarassing bug in PM QoS.

* Change disabling the OPPs API on configurations that don't support OPPs.

* PM core modification allowing devices to be unregistered during late
  suspend and early resume (you've seen it already).


 Documentation/power/opp.txt |    3 +++
 drivers/base/power/main.c   |   34 ++++++++++++++++++++++++++++++----
 kernel/pm_qos_params.c      |    4 ++--
 kernel/power/Kconfig        |    4 ++++
 4 files changed, 39 insertions(+), 6 deletions(-)

---------------

Colin Cross (1):
      PM / PM QoS: Fix reversed min and max

Mark Brown (1):
      PM / OPP: Hide OPP configuration when SoCs do not provide an implementation

Rafael J. Wysocki (1):
      PM: Allow devices to be removed during late suspend and early resume

