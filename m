Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1DUUKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:10:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab1DUUKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:10:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Two power management fixes for 2.6.39
Date: Thu, 21 Apr 2011 22:11:02 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104212211.03185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two power management fixes for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They fix bugs related to syscore_ops introduced earlier in this cycle.


 arch/x86/kernel/apm_32.c |    5 +++++
 drivers/base/syscore.c   |    2 ++
 drivers/xen/manage.c     |    9 ++++++++-
 kernel/kexec.c           |    7 +++++++
 kernel/power/hibernate.c |   10 ++++++++--
 kernel/power/suspend.c   |    5 ++++-
 6 files changed, 34 insertions(+), 4 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM: Fix error code paths executed after failing syscore_suspend()
      PM: Add missing syscore_suspend() and syscore_resume() calls

