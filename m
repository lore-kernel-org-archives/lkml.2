Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0KFFpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:45:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:36090 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0KFFpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:45:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,306,1286175600"; 
   d="scan'208";a="345338992"
Subject: Re: [RFC 1/4]x86: cleanup vector usage
From: Shaohua Li <shaohua.li@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <20101105205516.GB5678@lenovo>
References: <1288766658.23014.114.camel@sli10-conroe>
	 <20101105205516.GB5678@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 13:45:34 +0800
Message-ID: <1289022334.2029.3.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-06 at 04:55 +0800, Cyrill Gorcunov wrote:
> On Wed, Nov 03, 2010 at 02:44:18PM +0800, Shaohua Li wrote:
> > Cleanup the vector usage and make them continuous if possible.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> ...
> > -#define X86_PLATFORM_IPI_VECTOR		0xed
> > +#define X86_PLATFORM_IPI_VECTOR		0xf7
> >  
> >  /*
> >   * IRQ work vector:
> >   */
> > -#define IRQ_WORK_VECTOR			0xec
> > +#define IRQ_WORK_VECTOR			0xf6
> >  
> > -#define UV_BAU_MESSAGE			0xea
> > +#define UV_BAU_MESSAGE			0xf5
> >  
> >  /*
> >   * Self IPI vector for machine checks
> >   */
> > -#define MCE_SELF_VECTOR			0xeb
> > +#define MCE_SELF_VECTOR			0xf4
> >  
> >  /* Xen vector callback to receive events in a HVM domain */
> > -#define XEN_HVM_EVTCHN_CALLBACK		0xe9
> > +#define XEN_HVM_EVTCHN_CALLBACK		0xf3
> > +
> 
>  Hi Li, this is not just a cleanup -- irq priority were changed as
> well, but I suppose it's harmless ;)
I didn't change the local apic timer vector because the comments say the
priority is important. For others, I do suppose it's harmless.

