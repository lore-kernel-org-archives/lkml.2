Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab1CYHYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:24:38 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:54341 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933712Ab1CYHYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:34 -0400
Date: Fri, 25 Mar 2011 03:24:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
In-reply-to: <4D8B550D.5000409@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103250321480.32565@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Maybe there is some other way to handle asymmetry ??

When somebody invents a system that needs asymmetry on purpose,
that is the time to get fancy.  Until that day, simply print a
FW_BUG WARNING and fall back to default_idle().

cheers,
Len Brown, Intel Open Source Technology Center

