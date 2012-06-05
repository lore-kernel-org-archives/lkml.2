Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2FEQUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:20:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:48855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2FEQUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:20:09 -0400
Message-ID: <1338913190.2749.10.camel@twins>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 18:19:50 +0200
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	 <1338881971.28282.150.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
	 <1338912565.2749.9.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 16:18 +0000, Yu, Fenghua wrote:
> Actually some Linux people are adjusting online/offline CPU's based on
> workload to save power in their business. There are some advantages
> for online/offline CPU's than idling CPU's.

Like what? Offline is nothing more than a C state on x86. 
