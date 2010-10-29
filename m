Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0J2Fxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:53:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:48558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0J2Fxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,257,1286175600"; 
   d="scan'208";a="568445078"
Subject: Re: [PATCH -v3] x86: Disable x2apic if nox2apic is specified
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CC7C64A.4070809@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
	 <1287882149-29275-16-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1010241204470.2466@localhost6.localdomain6>
	 <4CC4AEAB.4030505@kernel.org>
	 <1288029002.2675.22.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4CC7C64A.4070809@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 28 Oct 2010 22:53:28 -0700
Message-Id: <1288331608.2717.14.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 23:27 -0700, Yinghai Lu wrote:
> For
> 1. x2apic preenabled system
> 2. first kernel have x2apic enabled, and try to kexec second kernel with "nox2apic"
> 
> Will put back cpu with apic id < 255 into xapic mode, instead of panic.
> 
> -v2: use x2apic_disabled instead of nox2apic, Suggested by Thomas
>      update x2apic_supported with x2apic_disabled, Suggested by Thomas
> 
> -v3: add checking for boot cpu apic id > 255. in that case will just panic
>      --- pointed out by Suresh.
> 

Can we please hold off in merging this patch for a bit? There are some
subtleties in going back to xapic when the platform/cpu's are in x2apic
mode. I will check and get back to you on this after KS.

thanks,
suresh

