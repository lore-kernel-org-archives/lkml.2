Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1CWDNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:13:53 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:63149 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1CWDNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:13:51 -0400
Date: Tue, 22 Mar 2011 23:13:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [RFC PATCH V4 3/5] cpuidle: default idle driver for x86
In-reply-to: <20110322123244.28725.32435.stgit@tringupt.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103222304300.10549@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123244.28725.32435.stgit@tringupt.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is this patch a step forward?

> +obj-$(CONFIG_X86)                              += default_driver.o

BTW, that's a pretty generic name for an x86 specific idle driver...

I think that on builds that support intel_idle and acpi_idle,
everything in this file will be unused, unless somebody uses some
debugging cmdline params that should have been deleted ages ago.

thanks,
Len Brown, Intel Open Source Technology Center

