Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2A0H1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:27:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35361 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2A0H0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/7] x86/irq related fix
Date: Thu, 26 Jan 2012 23:25:46 -0800
Message-Id: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F225190.00A4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

small cleanup with io_apic.c

e807126: x86, irq: kill create_irq()
6a4e909: iommu, irq: alloc irq_desc for dmar_msi with local node
5e6f66d: ia64, irq: add dummy create_irq_nr()
cbe7558: x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
b567f4c: x86, irq: Let msi-x to shown as MSI-X in /proc/interrupt
303205f: x86, irq: more clear about msix printout
c102aca: x86, irq: Modify irq chip one time when irq remapping is enabled

 arch/ia64/kernel/irq_ia64.c    |   10 +++++++
 arch/x86/include/asm/io_apic.h |    2 +
 arch/x86/kernel/apic/apic.c    |    9 +++++-
 arch/x86/kernel/apic/io_apic.c |   59 +++++++++++++++++++++++-----------------
 drivers/iommu/dmar.c           |    2 +-
 5 files changed, 55 insertions(+), 27 deletions(-)


