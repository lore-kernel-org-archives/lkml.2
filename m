Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1HDWbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:31:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22865 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1HDWbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:31:12 -0400
Date: Thu, 4 Aug 2011 18:30:18 -0400
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
Message-ID: <20110804223018.GA4370@dumpdata.com>
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
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020207.4E3B1D83.0061:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
> > >  arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
> > >  arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
> > >  arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
> > >  arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)
> > 
> > Oh, that I haven't seen. Can you send me the .config for that please.
> 
> You can't be trying very hard then.  I see lots of these (but no,

Hm, It is not obvious to me what is causing that compile failure. Any ideas?

> I haven't reported them.  One can grow weary of reporting xen bugs.)
> 
> 
> > > even after:
> > > 
> > >  b3c4b9825075: xen/tracing: fix compile errors when tracing is disabled.
> > > 
> > > Btw., that the heck is going on with the commit that introduced the 
> > > build failure:
> > > 
> > >  commit bd9ddc875b6659f9f74dcfd285c472bc58041abd
> > >  Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > >  AuthorDate: Mon Jun 20 17:52:13 2011 -0700
> > >  Commit:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > >  CommitDate: Mon Jul 18 15:43:46 2011 -0700
> > > 
> > > It was apparently rebased shortly before the merge window and sent to 
> > 
> > Well, the rebase I get - it was done on top of the merge that introduced
> > the new functionality.
> > 
> > > Linus 3 days later, with little to no linux-next testing ...
> > 
> > <Hmm> It did fix the compile problem.. albeit it created another one.
> > > 
> > > I'm absolutely unhappy about how the Xen tree is being run. It's 
> > > using a sloppy, crappy workflow and it is producing crap.
> > 
> > Do you have a manual of how you guys run your workflow?
> 
> I just run 30-50 randconfigs per night (cron job).

Ok, do you have an mailing list where you send the output too?
