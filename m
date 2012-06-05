Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2FEORE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:17:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753228Ab2FEORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:17:02 -0400
Date: Tue, 5 Jun 2012 10:17:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
In-Reply-To: <4FCD5F88.6050502@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1206051014540.1542-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Arjan van de Ven wrote:

> > I disagree.  Deactivating a cpu for power saving is halfway to hotplug
> > anyway.  I'd rather unify the two cases, where we can specify how dead a
> > CPU should be, than have individual archs and boards do random hacks.
> 
> well on PC's there really is no difference at least;
> idle equals "all power removed" already there.

This doesn't sound right at all.  Len Brown has often told us that on
Intel chips, power can't be removed from a package until _all_ the
cores in the package are idle.

Alan Stern

