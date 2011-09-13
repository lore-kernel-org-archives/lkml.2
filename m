Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1IMDIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 23:08:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:26305 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1IMDII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 23:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,372,1312182000"; 
   d="scan'208";a="48050779"
From: "Brown, Len" <len.brown@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Mon, 12 Sep 2011 20:08:05 -0700
Subject: [GIT] ACPI patches for 3.1-rc6
Thread-Topic: [GIT] ACPI patches for 3.1-rc6
Thread-Index: AcxxwlsJ34cFjk4gToyVdOlfsZLjAw==
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC829B3E488B@azsmsx503.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  https://github.com/lenb/linux.git acpi

Nothing Earth-shattering here, but also no reason to wait for 3.2.

With kernel.org down, this is my 1st attempt to use github.com --
let me know if you have any troubles with it.
Also, my email on kernel.org is kaput, so I'm looking for a new e-mail
flow for handling patches.  I'm open to recommendations.

thanks,
-Len


Bjorn Helgaas (1):
      PNP: update pnp.debug usage (needs value on command line)

Chen Gong (1):
      ACPI APEI: Add Kconfig option IRQ_WORK for GHES

Len Brown (2):
      acpica: ACPI_MAX_SLEEP should be 2 sec, not 20
      Merge branches 'apei', 'bz-13195' and 'doc' into acpi

Matthew Garrett (1):
      APEI: Fix WHEA _OSC call

 Documentation/kernel-parameters.txt |    9 ++++++---
 drivers/acpi/acpica/acconfig.h      |    2 +-
 drivers/acpi/apei/Kconfig           |    1 +
 drivers/acpi/apei/apei-base.c       |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

