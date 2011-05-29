Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1E2GzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 02:55:19 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:47465 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1E2GzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 02:55:17 -0400
Date: Sun, 29 May 2011 02:55:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.40
In-reply-to: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.02.1105290252150.7577@arrandale.kernel.org>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH 1/9] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
> [PATCH 2/9] lib, Add lock-less NULL terminated single list
> [PATCH 3/9] lib, Make gen_pool memory allocator lockless
> [PATCH 4/9] ACPI, APEI, GHES, printk support for recoverable error via NMI

I think the 4 above should go upstream to enable the
printk for recoverable errors.  If queuing messages
from NMI context gets re-implemented in the future,
then so be it.

I'll skip the rest, however, except #9:-)

thanks,
-Len

> [PATCH 5/9] HWPoison: add memory_failure_queue()
> [PATCH 6/9] ACPI, APEI, GHES: Add hardware memory error recovery support
> [PATCH 7/9] PCIe, AER, add aer_recover_queue
> [PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
> [PATCH 9/9] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
> 
