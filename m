Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1KHWAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:00:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1KHWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:00:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.2
Date: Tue, 8 Nov 2011 23:03:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111082303.21067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes (on top of commit
94956eed14b4b16d401c8ad36d68df0608f968cb) for 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes

with top-most commit 156acb166ea9a43d7fcdf9b8051694ce4e91dbfc
(PM / OPP: Use ERR_CAST instead of ERR_PTR(PTR_ERR())).

They include:

* PM QoS regression fix from Dominik Brodowski.

* devfreq structure field name fix from Jon Corbet.

* cgroups freezer documentation fix.

* Error pointer casting cleanup in OPP core from Thomas Meyer.

Thanks!


 Documentation/cgroups/freezer-subsystem.txt |    4 ++--
 drivers/base/power/opp.c                    |    2 +-
 include/linux/devfreq.h                     |    2 +-
 kernel/power/qos.c                          |    1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

---------------

Dominik Brodowski (1):
      PM / QoS: Set cpu_dma_pm_qos->name

Jonathan Corbet (1):
      PM / devfreq: fix private_data

Rafael J. Wysocki (1):
      Documentation: Fix typo in freezer-subsystem.txt

Thomas Meyer (1):
      PM / OPP: Use ERR_CAST instead of ERR_PTR(PTR_ERR())

