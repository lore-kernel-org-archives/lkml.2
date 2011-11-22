Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab1KVVl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:41:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:60944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708Ab1KVVlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:41:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,555,1315206000"; 
   d="scan'208";a="88279787"
Subject: [PATCH v3 0/2] KT serial controller IIR workaround
To: gregkh@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Date: Tue, 22 Nov 2011 13:41:19 -0800
Message-ID: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2 [1]:
* reflowed on tty-next (commit: 161e773c "UART: add CSR SiRFprimaII..."
* add a quirk to turn on msi to try to prevent shared interrupts

[1]: https://lkml.org/lkml/2011/11/15/264

---

Dan Williams (2):
      serial/8250_pci: setup-quirk workaround for the kt serial controller
      serial/8250_pci: init-quirk msi support for kt serial controller


 drivers/tty/serial/8250.c     |    4 +++-
 drivers/tty/serial/8250_pci.c |   31 ++++++++++++++++++++++++++++++-
 include/linux/serial_core.h   |    1 +
 3 files changed, 34 insertions(+), 2 deletions(-)
