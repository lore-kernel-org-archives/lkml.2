Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1DOTUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:20:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30185 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1DOTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:20:04 -0400
Message-ID: <4DA899EA.8010602@kernel.org>
Date: Fri, 15 Apr 2011 12:18:02 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <4DA8535B.4080901@gmail.com> <20110415142724.GK18463@8bytes.org> <4DA895A2.4060307@gmail.com> <20110415190641.GA20770@elte.hu>
In-Reply-To: <20110415190641.GA20770@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DA89A30.005C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 12:06 PM, Ingo Molnar wrote:

> 
> Joerg, mind submitting it with a changelog that includes everything we learned 
> about this bug and all the Tested-by's in place?
> 
> Is anyone of the opinion that we should try to revert the allocation 
> order/alignment changes in addition to this fix?

We should figure out what is written to 0xa0001000 (main memory) by GPU before internal GART is setup.

Joerg,
can you insert some dump code in the drm/radon code to find out which function cause the problem?

Thanks

Yinghai
