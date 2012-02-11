Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2BKXDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:03:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab2BKXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:02:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Sleep: Suspend core code cleanups
Date: Sun, 12 Feb 2012 00:03:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202120003.20879.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches clean up the core system suspend code.

[1/3] - Unify and improve kerneldoc comments in kernel/power/suspend.c.
[2/3] - Make enter_state() in kernel/power/suspend.c static.
[3/3] - Drop suspend_stats_update() and move its code to the caller.

They are on top of the patch at:

http://marc.info/?l=linux-kernel&m=132891673021129&w=4

and are v3.4 candidates.

Thanks,
Rafael

