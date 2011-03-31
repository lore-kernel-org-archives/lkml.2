Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab1CaNUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:20:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:38796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1CaNUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:20:04 -0400
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
In-Reply-To: <alpine.LFD.2.02.1103302203490.1920@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
	 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
	 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
	 <4D89CA7D.8080108@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103231623450.12911@x980>
	 <4D8B550D.5000409@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1103250321480.32565@x980>
	 <20110325180156.GC19214@dirshya.in.ibm.com>
	 <alpine.LFD.2.02.1103302203490.1920@x980>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 15:18:56 +0200
Message-ID: <1301577536.4859.249.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 22:17 -0400, Len Brown wrote:
> 
> Moorestown is already an example of an asymmetric system,
> since its deepest c-state is available on cpu0, but not on cpu1.
> So it needs different tables for each cpu. 

wtf are these hardware guys smoking and how the heck are we supposed to
schedule on such a machine? Prefer to keep cpu1 busy while idling cpu0?
