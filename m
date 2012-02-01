Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab2BAWnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:43:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32928 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2BAWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:43:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "Cc: Dominik Brodowski" <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/7] PCI : bridge resource reallocation patchset -- followup
Date: Wed,  1 Feb 2012 14:42:43 -0800
Message-Id: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F29BFF8.00BC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e4afda7: PCI: only enable pci realloc when SRIOV bar is not assigned
fee4a1e: PCI: print out suggestion about using pci=realloc
83f0fb3: PCI: Make pci bridge reallocating enabled/disabled
3ede49c: PCI: Retry on type IORESOURCE_IO allocation.
6becd43: PCI: Skip reset cardbus assigned resource during pci bus rescan
51f1186: PCI: Fix cardbus bridge resources as optional size handling
aa85d79: PCI: Disable cardbus bridge MEM1 pref CTL

are left over after Jesse pickup more of them.
it will try to auto detect if need to use pci=realloc, and print out suggestion.

including fixing some pci carbus handling.

could get from

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci3

Thanks

Yinghai

 Documentation/kernel-parameters.txt |    8 ++-
 drivers/pci/pci.c                   |    4 +-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/setup-bus.c             |  159 +++++++++++++++++++++++++----------
 4 files changed, 125 insertions(+), 48 deletions(-)




