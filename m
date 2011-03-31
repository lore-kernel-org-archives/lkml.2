Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab1CaV1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:27:09 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:56376 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1CaV1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:27:08 -0400
Date: Thu, 31 Mar 2011 17:26:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com, Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
In-reply-to: <alpine.LFD.2.02.1103302159010.1920@x980>
Message-id: <alpine.LFD.2.02.1103311724100.9662@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231659210.12911@x980>
 <20110324120522.GB29294@dumpdata.com> <4D8CA902.7090907@goop.org>
 <alpine.LFD.2.02.1103302159010.1920@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> xen_arch_setup() does this:
> > >>
> > >>         pm_idle = default_idle;
> > >>         boot_option_idle_override = IDLE_HALT;

What happens on a Xen kernel if these lines are not there?
Does Xen export the C-states tables to Dom0 kernel, and the Dom0
kernel has an acpi processor driver, and thus it would try to
use all the C-states?

If yes, must Xen show those tables to Dom?
If it did not, then the lines above would not be necessary,
as in the absence of any C-states, the kernel should
use halt by default.

thanks,
-Len Brown, Intel Open Source Technology Center

