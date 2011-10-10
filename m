Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1JJPZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:25:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43913 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751429Ab1JJPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:25:29 -0400
Date: Mon, 10 Oct 2011 11:25:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, <rjw@sisk.pl>,
        <bp@amd64.org>, <pavel@ucw.cz>, <len.brown@intel.com>, <tj@kernel.org>,
        <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <suresh.b.siddha@intel.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <rdunlap@xenotime.net>,
        <vatsa@linux.vnet.ibm.com>, <ashok.raj@intel.com>,
        <tigran@aivazian.fsnet.co.uk>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
In-Reply-To: <1318256788.14400.53.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1110101123200.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Peter Zijlstra wrote:

> I just remember being very surprised about finding out the hotplug usage
> of suspend/hibernate wasn't at all serialized against the regular
> hotplug thingies.. (see 144060fee07e9c22e179d00819c83c86fbcbf82c).

It _is_ serialized against some of them... maybe not all, though.  
That's one of the purposes of the "prepare" and "complete" callback
methods in dev_pm_ops.

Alan Stern

