Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1JKJLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:11:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:39321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1JKJLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:11:51 -0400
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tj@kernel.org" <tj@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
In-Reply-To: <20111010165343.GA29261@aftab>
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
	 <4E931018.8030904@linux.vnet.ibm.com>  <20111010165343.GA29261@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 11:17:54 +0200
Message-ID: <1318324674.14400.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 18:53 +0200, Borislav Petkov wrote:
> 
> Yes, agreed. And more: I'm still trying to understand why a test case
> like that is relevant and needs to be fixed at all. Let me re-formulate
> the question: what real world scenario(s) does the case of hibernating
> _while_ off- and onlining cores cover? Or are you simply doing kernel
> resiliency testing and thought that offlining cores while hibernating
> might make sense? 

It can happen, therefore it will. We had better deal with it.

