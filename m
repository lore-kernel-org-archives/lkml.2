Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2FEHjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:39:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55828 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2FEHjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:39:45 -0400
Message-ID: <1338881971.28282.150.camel@twins>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 09:39:31 +0200
In-Reply-To: <87zk8iioam.fsf@rustcorp.com.au>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 10:10 +0930, Rusty Russell wrote:
> I disagree.  Deactivating a cpu for power saving is halfway to hotplug
> anyway.  

No, that's only so for broken hardware. On sane hardware idling is
sufficient.
