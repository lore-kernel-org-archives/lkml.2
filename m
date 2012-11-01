Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544Ab2KAOuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:50:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8905 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab2KAOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:50:04 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com, prarit@redhat.com,
        bhelgaas@google.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 0/2] ACPI: CPU hot-remove support
Date: Thu,  1 Nov 2012 08:42:11 -0600
Message-Id: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support of CPU hot-remove via an ACPI eject
notification to the ACPI processor driver.  The CPU hot-remove
operation shares the same code path with the sysfs eject operation.

The patchset also exports two functions necessary to initiate
hot-remove operations from modules, such as the processor driver.

The patchset is based on the current Linus's tree.

v3:
- Added patch 1/2 to export functions for hot-remove

v2:
- Rebased to the latest baseline

---
Toshi Kani (2):
 ACPI: Export functions for hot-remove
 ACPI: Add ACPI CPU hot-remove support

---
 drivers/acpi/osl.c              |  1 +
 drivers/acpi/processor_driver.c | 27 +++++++++++++++++----------
 drivers/acpi/scan.c             |  1 +
 3 files changed, 19 insertions(+), 10 deletions(-)
