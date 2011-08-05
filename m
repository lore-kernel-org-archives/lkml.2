Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1HEJo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:44:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1HEJo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:44:27 -0400
Date: Fri, 5 Aug 2011 11:43:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't
 already
Message-ID: <20110805094319.GA2420@elte.hu>
References: <cover.1312386029.git.luto@mit.edu>
 <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980>
 <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
 <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
 <alpine.LFD.2.02.1108031514550.22067@x980>
 <20110804194117.GA5265@srcf.ucam.org>
 <alpine.LFD.2.02.1108041751360.24626@x980>
 <20110804215619.GA7101@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804215619.GA7101@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Aug 04, 2011 at 05:54:04PM -0400, Len Brown wrote:
> > > We can't trust BIOS authors to get things right. Where we can reliably 
> > > fix up things that are broken, we should do so.
> > 
> > How about if we can get a BIOS fix for this brand new system, 
> > then we shall not clutter the kernel with a workaround, otherwise 
> > we shall.
> 
> It's a pretty good rule of thumb that if a BIOS bug is present in 
> one BIOS it's present in others, but the users will just never 
> notice.

Yes. There's no harm really from working around a BIOS bug and 
warning about it - when the BIOS gets fixed the warning message will 
go away.

Btw., few people risk upgrading their BIOSen on already purchased 
hardware. I almost never do it, i only do it if it's impossible to 
continue with a current BIOS.

Thanks,

	Ingo
