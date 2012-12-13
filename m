Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2LMTYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:24:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:14339 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab2LMTYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:24:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,275,1355126400"; 
   d="scan'208";a="263660213"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/3] Thunderbolt workarounds
Date: Thu, 13 Dec 2012 21:25:18 +0200
Message-Id: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

I had chance to test two PC setups with Thunderbolt: Acer Aspire S5 and
Intel DZ77RE-75K motherboard. Unfortunately, both of them are broken in
different ways.

This patchset contains workarounds for the issues.

Kirill A. Shutemov (3):
  PCI Hotplug: workaround for Thunderbolt on Acer Aspire S5
  PCI Hotplug: convert acpiphp_hp_work to use delayed work
  PCI Hotplug: workaround for Thunderbolt on Intel DZ77RE-75K
    motherboard

 drivers/pci/hotplug/acpi_pcihp.c   |   13 +++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c |   33 +++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.7.10.4

