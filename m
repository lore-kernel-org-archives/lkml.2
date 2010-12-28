Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0L1Pc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:32:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0L1PcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:32:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/4] ACPI / PM: Use standard device wakeup facilities for ACPI wakeup devices
Date: Tue, 28 Dec 2010 16:25:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012281625.36191.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches causes standard device wakeup facilities to be used
with ACPI wakeup devices, like buttons.

[1/4] - Modify /proc/acpi/wakeup not to enable multiple devices at a time to
        wake up the system from sleep states, even if they share a GPE.

[2/4] - Use standard device wakeup flags for handling ACPI wakeup devices.

[3/4] - Remove special ACPI wakeup flags.

[4/4] - Report wakeup events for ACPI buttons and lids.

The patches have been tested with Toshiba Portege R500.

Thanks,
Rafael

