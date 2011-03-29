Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1C2Jk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:40:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1759 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1C2Jk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:40:27 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rmk+kernel@arm.linux.org.uk
cc: gregkh@suse.de, linux-wireless@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH 0/1] new module for amba axi on-chip interconnect
Date: Tue, 29 Mar 2011 11:40:18 +0200
Message-ID: <1301391619-4499-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
X-WSS-ID: 618F762F3I83457961-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GUIDANCE NEEDED:
This patch puts the module at proposed location. Please provide your
guidance if there is a better location within the linux tree for this
module.

This module has been isolated from the brcm80211 driver currently
located in staging and provided to other drivers for chipsets using
the AMBA AXI on-chip interconnect with ARM Device Management Plugin
(DMP) silicon IP, which provides system discovery (chip being the
system) and basic core function (disable, reset, etc.).

The module has previously been posted on the linux-wireless list and
comments by Randy Dunlap have been taken in. Also the SubmitChecklist
has been followed.

Arend van Spriel (1):
  drivers: brcmaxi: provide amba axi functionality in separate module

 drivers/Kconfig            |    2 +
 drivers/Makefile           |    1 +
 drivers/brcmaxi/Kconfig    |   23 ++
 drivers/brcmaxi/Makefile   |   25 ++
 drivers/brcmaxi/axi.c      |  786 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/brcmaxi/axi_priv.h |   51 +++
 drivers/brcmaxi/pci.c      |  118 +++++++
 include/brcmaxi/amba.h     |   87 +++++
 include/brcmaxi/axi.h      |  310 +++++++++++++++++
 include/brcmaxi/pci.h      |  112 +++++++
 10 files changed, 1515 insertions(+), 0 deletions(-)
 create mode 100644 drivers/brcmaxi/Kconfig
 create mode 100644 drivers/brcmaxi/Makefile
 create mode 100644 drivers/brcmaxi/axi.c
 create mode 100644 drivers/brcmaxi/axi_priv.h
 create mode 100644 drivers/brcmaxi/pci.c
 create mode 100644 include/brcmaxi/amba.h
 create mode 100644 include/brcmaxi/axi.h
 create mode 100644 include/brcmaxi/pci.h


