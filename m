Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0LCA3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:29:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0LCA3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:29:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM: Changes related to wakeup events
Date: Fri, 3 Dec 2010 01:18:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030118.30603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches change the way in which wakeup events are taken
into account by dpm_prepare() and dpm_suspend().

[1/3] - Prevent dpm_prepare() from aborting suspend if events_check_enabled is
        unset.

[2/3] - Replace pm_check_wakeup_events() with pm_wakeup_pending() to avoid
        confision with the return value.

[3/3] - Check pm_wakeup_pending() in device_suspend().

If there are no objections, I'm going to queue them up for 2.6.38.

Thanks,
Rafael

