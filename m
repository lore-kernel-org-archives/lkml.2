Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab1DPMBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 08:01:51 -0400
Received: from 8bytes.org ([88.198.83.132]:57671 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759327Ab1DPMBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 08:01:44 -0400
Date: Sat, 16 Apr 2011 14:01:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110416120143.GR18463@8bytes.org>
References: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <4DA8535B.4080901@gmail.com> <20110415142724.GK18463@8bytes.org> <4DA895A2.4060307@gmail.com> <20110415190641.GA20770@elte.hu> <4DA899EA.8010602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA899EA.8010602@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:18:02PM -0700, Yinghai Lu wrote:
> On 04/15/2011 12:06 PM, Ingo Molnar wrote:
> 
> > 
> > Joerg, mind submitting it with a changelog that includes everything we learned 
> > about this bug and all the Tested-by's in place?
> > 
> > Is anyone of the opinion that we should try to revert the allocation 
> > order/alignment changes in addition to this fix?
> 
> We should figure out what is written to 0xa0001000 (main memory) by GPU before internal GART is setup.
> 
> Joerg,
> can you insert some dump code in the drm/radon code to find out which
> function cause the problem?

I am not a GPU expert, but I will see what I can find out.

	Joerg

