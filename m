Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1HFTrN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:47:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51732 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab1HFTrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:47:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Two power management fixes for 3.1
Date: Sat, 6 Aug 2011 21:48:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108062148.45132.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two power management fixes for 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

The first one fixes a mistake in (recently merged) pm_genpd_poweron() and
the second one makes the runtime PM framework be a bit more friendly to
driver writers.

Thanks!


 Documentation/power/runtime_pm.txt |   10 +++++-----
 drivers/base/power/domain.c        |    3 +--
 drivers/base/power/runtime.c       |   10 ++++++++--
 3 files changed, 14 insertions(+), 9 deletions(-)

---------------

Kevin Hilman (1):
      PM / Runtime: Allow _put_sync() from interrupts-disabled context

Rafael J. Wysocki (1):
      PM / Domains: Fix pm_genpd_poweron()

