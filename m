Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2LSUbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:31:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2LSUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:31:26 -0500
Subject: [PATCH 0/2] goldfish: base support
To: x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
From: Alan Cox <alan@linux.intel.com>
Date: Wed, 19 Dec 2012 20:34:05 +0000
Message-ID: <20121219203018.9208.67869.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the base component of the Goldfish virtual android device on x86 systems.

These need to be merged first so the driver support can follow


---

Jun Nakajima (2):
      goldfish: definitions for Goldfish on x86 platforms
      goldfish: add the goldfish virtual bus


 arch/x86/Kconfig                     |   12 ++
 arch/x86/include/asm/goldfish.h      |   33 ++++
 drivers/platform/Makefile            |    1 
 drivers/platform/goldfish/Makefile   |    4 +
 drivers/platform/goldfish/pdev_bus.c |  265 ++++++++++++++++++++++++++++++++++
 5 files changed, 315 insertions(+)
 create mode 100644 arch/x86/include/asm/goldfish.h
 create mode 100644 drivers/platform/goldfish/Makefile
 create mode 100644 drivers/platform/goldfish/pdev_bus.c

-- 
Signature
