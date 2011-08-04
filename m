Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1HDWdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:33:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1HDWdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:33:37 -0400
Date: Thu, 4 Aug 2011 18:32:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: linux-next: Tree for July 25 (xen)
Message-ID: <20110804223259.GB4370@dumpdata.com>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
 <20110725144629.b752bf14.rdunlap@xenotime.net>
 <20110804193534.GB12729@elte.hu>
 <20110804195539.GA11198@dumpdata.com>
 <20110804131516.c4da6595.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110804131516.c4da6595.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E3B1E26.0020,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > These build failures are still triggering upstream:
> > > 
> > >  arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
> > >  arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
> > >  arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
> > >  arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
> > >  arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)
> > 
> > Oh, that I haven't seen. Can you send me the .config for that please.
> 
> You can't be trying very hard then.  I see lots of these (but no,

Ah, I am getting it now. Thanks for reporting it.
