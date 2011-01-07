Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1AGArq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:47:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38176 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1AGArp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:47:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/5] PM / ACPI: Fix problems with ACPI NVS saving related to using ioremap_cache() by ACPI
Date: Fri, 7 Jan 2011 01:41:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070141.02951.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches makes the NVS save/restore code work correctly
if ioremap_cache() is used by ACPI.

[1/5] - Fix Oops in the NVS saving code related to failing ioremap()
        (patch from Jiri).

[2/5] - Move the NVS save/restore code to drivers/acpi.

[3/5] - Update file information and the list of includes in nvs.c.

[4/5] - Make suspend_nvs_save() use acpi_os_map_memory().

[5/5] - Make ACPI use ioremap_cache() internally.

Please review/test.

Do you want me to take these patches to my tree or are you going to push them
to Linus?

Rafael

