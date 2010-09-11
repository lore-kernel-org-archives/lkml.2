Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0IKUs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:48:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab0IKUs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:48:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes for 2.6.36
Date: Sat, 11 Sep 2010 22:47:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        mark gross <markgross@thegnar.org>, Colin Cross <ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009112247.15602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They include:

 * Device suspend error code path fix related to asynchronous suspend/resume
   from Colin Cross.

 * PM QoS fix from Mark Gross.

 * Hibernate fix affecting systems with lots of highmem.


 drivers/base/power/main.c |    1 +
 kernel/pm_qos_params.c    |    4 ++-
 kernel/power/snapshot.c   |   85 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 69 insertions(+), 21 deletions(-)

---------------

Colin Cross (1):
      PM: Prevent waiting forever on asynchronous resume after failing suspend

Rafael J. Wysocki (1):
      PM / Hibernate: Avoid hitting OOM during preallocation of memory

mark gross (1):
      PM QoS: Correct pr_debug() misuse and improve parameter checks

