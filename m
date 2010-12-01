Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab0LAG4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:56:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:6382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0LAGz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:55:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="355374097"
Message-Id: <20101201062225.292364637@intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 30 Nov 2010 22:22:25 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@kernel.org
Subject: [patch 0/4] x86, intr-remapping patches for addressing kexec/kdump issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches address/workaround the issues we have identified
with the interrupt-remapping code flow while debugging hangs/spurious NMI's
we have seen with different OEM platforms during kexec/kdump in the
presence of interrupt-remapping (and x2apic in some cases).

All the patches are small and self-contained and are marked stable
as it makes kexec/kdump functional on these platforms. While some of these
patches touch pci files and self-contained, I would appreciate if all
these patches get routed to Linus tree (for v2.6.37) through -tip tree.

thanks,
suresh

