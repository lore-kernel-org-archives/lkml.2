Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0L2MXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:23:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0L2MXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:23:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] PCI / PM: Updates related to wakeup events
Date: Wed, 29 Dec 2010 13:20:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291320.22777.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches modify the PCI power management core's handling
of wakeup events:

[1/2] - Replace pci_wakeup_event() with a static inline function.

[2/2] - Report PCI wakeup events before resuming the involved devices.

The patches have been tested on multiple machines.

Please apply.

Thanks,
Rafael

