Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1GPVuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 17:50:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1GPVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 17:50:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] MIPS build fix related to power management for 3.0
Date: Sat, 16 Jul 2011 23:50:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107162350.51025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a MIPS build fix related to PM for 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It fixes a build regression resulting from a missing conversion from using
a sysdev to using syscore_ops for PM/shutdown in the MIPS tree.


 arch/mips/kernel/i8259.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

----------

Rafael J. Wysocki (1):
      PM / MIPS: Convert i8259.c to using syscore_ops

