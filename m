Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1HYTFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:05:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:59701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab1HYTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,282,1312182000"; 
   d="scan'208";a="11095038"
Message-Id: <20110825190110.255432370@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 25 Aug 2011 12:01:10 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trenn@suse.de, suresh.b.siddha@intel.com, rjw@novell.com,
        macro@linux-mips.org, lchiquitto@novell.com, jbeulich@novell.com,
        yinghai@kernel.org
Subject: [patch v2 0/3] ioapic kdump, eoi fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 of the original series
http://marc.info/?l=linux-kernel&m=131309907720703&w=2

Changes in v2:
* Make sure that the IO-APIC RTE trigger mode is set to level trigger
  in clear_IO_APIC_pin() before doing EOI to clear the remoteIRR.

thanks,
suresh

