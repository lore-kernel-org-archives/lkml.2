Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab0FKUQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:16:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab0FKUQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:16:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fix for 2.6.35
Date: Fri, 11 Jun 2010 22:14:40 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Ondrej Zary <linux@rainbow-software.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <201006112210.25688.rjw@sisk.pl>
In-Reply-To: <201006112210.25688.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006112214.40440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the duplicate, forgot to send to the lists.]

Hi Linus,

Please pull an x86 resume fix from

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This fixes a nasty crash occuring during resume on boxes that
wake up with MWAIT disabled.


 arch/x86/include/asm/suspend_32.h |    2 ++
 arch/x86/include/asm/suspend_64.h |    2 ++
 arch/x86/power/cpu.c              |    4 ++++
 3 files changed, 8 insertions(+), 0 deletions(-)

---------------

Ondrej Zary (1):
      PM / x86: Save/restore MISC_ENABLE register

