Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1HQSkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:40:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab1HQSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:40:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management build fix for 3.1
Date: Wed, 17 Aug 2011 20:41:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108172041.48394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management build fix for 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes

This makes the new generic PM domains code build correctly
if CONFIG_PM_RUNTIME is unset.

Thanks!


 drivers/base/power/domain.c |   30 +++++++++++++++---------------
 include/linux/pm_domain.h   |   10 +++++++---
 kernel/power/Kconfig        |    4 ++++
 3 files changed, 26 insertions(+), 18 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM / Domains: Fix build for CONFIG_PM_RUNTIME unset

