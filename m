Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0EKPvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:51:10 -0400
Received: from www.tglx.de ([62.245.132.106]:54141 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab0EKPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:51:06 -0400
Date: Tue, 11 May 2010 17:50:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 4/8] x86/mrst: change clock selection logic to support
 medfield
In-Reply-To: <20100511163054.365239fe@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1005111748040.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005111546260.3401@localhost.localdomain> <20100511163054.365239fe@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Alan Cox wrote:

> > > +	pr_debug("cpuid result %x\n", regs[CR_EAX]);
> > > +	pr_info("Moorestown CPU %s identified\n",
> > > +		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
> > > +		"Lincroft" : "Penwell");
> > 
> >   Are we going to add one of those for each new family ? This is
> >   really redundant bloat with no value.
> > 
> > > +	return mrst_cpu_chip;
> 
> From the driver side we need this value determined and visible to the
> drivers because some things like the IPC interface need to know rather
> than getting the cpuid magic replicated around.

Ok. That makes sense. Is there more what MRST drivers need to know ?

Thanks,

	tglx

