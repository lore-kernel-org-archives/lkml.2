Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1CBSMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:12:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51679 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab1CBSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:12:38 -0500
Message-ID: <4D6E8874.6070000@zytor.com>
Date: Wed, 02 Mar 2011 10:12:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
References: <20110226143730.GA26864@htj.dyndns.org> <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com> <20110302161900.GP3319@htj.dyndns.org> <AANLkTi=SYRK+iKT-Zwuyv=e6dLqmoL4cUts2Xoyq-M=1@mail.gmail.com> <20110302170702.GS3319@htj.dyndns.org> <20110302180827.GA13693@elte.hu>
In-Reply-To: <20110302180827.GA13693@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 10:08 AM, Ingo Molnar wrote:
> 
>> To me, it seems complicated for not good enough reasons.  I'll defer
>> the decision to x86 maintainers.  Ingo, hpa, Thomas, what do you guys
>> think?
> 
> Would be nice to see an actual patch that does the revert.
> 

I also would like to point out that we are at -rc7.  The time to test
new things is quickly running out, so a more conservative option for
this upcoming merge window is starting to look good.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

