Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0JVEEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:04:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61803 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0JVEEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:04:35 -0400
Message-ID: <4CC10D07.6000303@kernel.org>
Date: Thu, 21 Oct 2010 21:03:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gianluca Guida <gianluca.guida@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20101022140335.c4a3a48f.sfr@canb.auug.org.au> <20101022143607.132d381c.sfr@canb.auug.org.au>
In-Reply-To: <20101022143607.132d381c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 08:36 PM, Stephen Rothwell wrote:
> Hi Jeremy,
> 
> On Fri, 22 Oct 2010 14:03:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the xen tree got a conflict in
>> arch/x86/mm/init_32.c between commit
>> 1d931264af0f10649b35afa8fbd2e169da51ac08 ("x86-32, memblock: Make
>> add_highpages honor early reserved ranges") from the tip tree and commit
>> 07147a06ac3b1b028124ea00ba44e69eb8ea7685 ("x86/32: honor reservations of
>> high memory") from the xen tree.
>>
>> I have no idea how to fix this up, sorry, so I have used the xen tree
>> from next-20101021 for today.
> 

x86-32, memblock: Make add_highpages honor early reserved ranges

is updated version with memblock for

x86/32: honor reservations of high memory

Assume Jeremy would update the xen tree.

Thanks

	Yinghai

