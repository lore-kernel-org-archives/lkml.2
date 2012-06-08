Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab2FHJUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:20:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:40976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab2FHJUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:20:45 -0400
Message-ID: <1339147226.23343.50.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2012 11:20:26 +0200
In-Reply-To: <20120606232055.GO19601@linux.vnet.ibm.com>
References: <3908561D78D1C84285E8C5FCA982C28F19300965@ORSMSX104.amr.corp.intel.com>
	 <1338918625.2749.29.camel@twins> <alpine.LFD.2.02.1206052106440.3086@ionos>
	 <1338925756.2749.36.camel@twins> <alpine.LFD.2.02.1206052153200.3086@ionos>
	 <1338931856.2749.57.camel@twins> <20120605221240.GW2388@linux.vnet.ibm.com>
	 <1338972175.2749.78.camel@twins>
	 <20120606144417.GH19601@linux.vnet.ibm.com>
	 <1338997600.2749.146.camel@twins>
	 <20120606232055.GO19601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 16:20 -0700, Paul E. McKenney wrote:
> 
> Thomas's strong model also supports a strong form of idle, as well as the
> while(1) stuff, both of which have their uses. 

Just the while(1), the idle thing is independent.
