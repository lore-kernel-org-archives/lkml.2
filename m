Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1HYS1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:27:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56125 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1HYS1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:27:08 -0400
Message-ID: <4E5693DD.2010307@zytor.com>
Date: Thu, 25 Aug 2011 11:26:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20110825142450.c84e02d8763cfd1a93411844@canb.auug.org.au> <4E5690C3.2050706@goop.org>
In-Reply-To: <4E5690C3.2050706@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 11:13 AM, Jeremy Fitzhardinge wrote:
> On 08/24/2011 09:24 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the xen tree got a conflict in
>> arch/x86/include/asm/spinlock.h between a series of commits from the tip
>> tree and a smaller series of similar commits from the xen tree.
>>
>> I see that Linus is commenting on these patches at the moment, and its
>> not easy to resolve the conflicts, so I will just use the xen tree from
>> next-20110824 for today.
>>
> 
> Thanks Stephen; the xen tree ones are more current, and I want to make
> sure I didn't screw up any of the cmpxchg/xadd changes in a wider test env.
> 

Stephen: the x86/spinlocks branch in the -tip tree is obsolete and
should be dropped.

	-hpa

