Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1HXAtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:49:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:64483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1HXAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:49:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41195055"
Message-Id: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Aug 2011 17:05:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org
Cc: yinghai@kernel.org, youquan.song@intel.com, joerg.roedel@amd.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: [patch 0/8] intel iommu, irq-remap, x2apic bug fixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic opt out patch and the iommu parse device scope patch were held up
on the request of some code cleanups in this area.

Refer http://marc.info/?l=linux-kernel&m=131261409128226&w=2
and http://marc.info/?l=linux-pci&m=131157843015411&w=2

This series attempts to address the bug fixes aswell as the code cleanups.

thanks,
suresh

