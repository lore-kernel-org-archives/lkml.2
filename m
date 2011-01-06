Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1AFWpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:45:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab1AFWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:43:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/11] Various ACPI patches for 2.6.38
Date: Thu, 6 Jan 2011 23:31:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062331.17079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this series there are several ACPI patches I'd like to go into 2.6.38.
Some of them have been posted to linux-acpi already, some others are new.

[1/11] - Fix global lock acquisition (this patch is the same as
         https://patchwork.kernel.org/patch/435861/).

[2/11] - Prevent /proc/acpi/wakeup from enabling multiple devices to
         wake up simultaneously (this patch is the same as
         https://patchwork.kernel.org/patch/436351/).

[3/11] - Make the button driver use standard device wakeup flags
         (same as https://patchwork.kernel.org/patch/436321/).

[4/11] - Drop special ACPI wakeup flags that aren't necessary any more
         (same as https://patchwork.kernel.org/patch/436341/).

[5/11] - Use pm_wakeup_event() to report wakeup events from ACPI buttons
         (same as https://patchwork.kernel.org/patch/436331/).

[6/11] - Blacklist Averatec box requiring acpi_sleep=nonvs (new patch).

[7/11] - Rename acpi_power_off_device() (new patch).

[8/11] - Check status of power resources under mutexes (new patch).

[9/11] - Avoid printing messages about missing _PRW methods unnecessarily
         (new, fixes a glitch introduced by one of the recent regression fixes,
         -stable material).

[10/11] - Remove the wake_capable flag which isn't really useful (new patch).

[11/11] - Refresh battery information on 0x81 notification and during resume
          (new patch, based on the Matthew's battery patch we discussed some
          time ago).

Please consider for applying.

[NOTE: This series doesn't contain patches that depend on the latest ACPICA
 update and fix/modify changes made by it.]

Thanks,
Rafael

