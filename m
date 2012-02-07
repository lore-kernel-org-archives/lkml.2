Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2BGVS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:18:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab2BGVS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:18:27 -0500
Date: Tue, 7 Feb 2012 19:15:46 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/1] kvm : vmx : Remove yield_on_hlt
Message-ID: <20120207211546.GA23022@amt.cnet>
References: <20120207174919.3848.99779.sendpatchset@oc5400248562.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207174919.3848.99779.sendpatchset@oc5400248562.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 11:19:20PM +0530, Raghavendra K T wrote:
>   yield_on_hlt was introduced for CPU bandwidth capping. now it is redundant
> with CFS hardlimit.
> 
> yield_on_hlt also complicates the scenario in paravirtual environment, that
> needs to trap halt. for e.g. paravirtualized ticket spinlocks.
> 
> Changelog:
> Remove the support for yield_on_hlt.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Applied, thanks.

