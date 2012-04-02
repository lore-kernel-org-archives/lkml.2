Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2DBJm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:42:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:59402 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2DBJm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:42:56 -0400
X-IronPort-AV: E=Sophos;i="4.75,356,1330905600"; 
   d="scan'208";a="11716944"
Message-ID: <1333359773.25602.24.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC V6 0/11] Paravirtualized ticketlocks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Attilio Rao <attilio.rao@citrix.com>, "Ingo Molnar" <mingo@elte.hu>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Date: Mon, 2 Apr 2012 10:42:53 +0100
In-Reply-To: <alpine.LFD.2.02.1203302333560.2542@ionos>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
	 <4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 23:07 +0100, Thomas Gleixner wrote:
> So if we need to fiddle with the scheduler and frankly that's the only
> way to get a real gain (the numbers, which are achieved by this
> patches, are not that impressive) then the question arises whether we
> should turn the whole thing around.

It probably doesn't materially effect your core point (which seems valid
to me) but it's worth pointing out that the numbers presented in this
thread are AFAICT mostly focused on ensuring that that the impact of
this infrastructure is acceptable on native rather than showing the
benefits for virtualized workloads.

Ian.

