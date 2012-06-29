Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2F2ViT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 17:38:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab2F2ViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 17:38:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.5-rc5
Date: Fri, 29 Jun 2012 23:43:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Mandeep Singh Baines <msb@chromium.org>, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206292343.44673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 3.5-rc5 since commit
6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4

with top-most commit 75cc52358799bd6001e7d1a47847f997f5ae99f0

  PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup.

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.5-rc5

They are a fix for a bug in async suspend error code path causing parents to
wait forever for their children in case of a suspend error (-stable material)
and an ACPI cpuidle regression fix.

Thanks!


 drivers/acpi/processor_idle.c | 32 ++++++++++++++++++++++++++++++--
 drivers/base/power/main.c     |  6 ++++--
 2 files changed, 34 insertions(+), 4 deletions(-)

---------------

Deepthi Dharwar (1):
      PM / ACPI: Fix suspend/resume regression caused by cpuidle cleanup.

Mandeep Singh Baines (1):
      PM / Sleep: Prevent waiting forever on asynchronous suspend after abort

