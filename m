Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab2B2Foq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:44:46 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38814 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2B2Fop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:44:45 -0500
Message-ID: <4F4DBB26.2060907@linux.vnet.ibm.com>
Date: Wed, 29 Feb 2012 11:14:06 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org>
In-Reply-To: <20120228132719.f375071a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022819-1396-0000-0000-000000BECF33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 02/29/2012 02:57 AM, Andrew Morton wrote:

> On Tue, 28 Feb 2012 09:43:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> This patch should also probably go upstream through the 
>> locking/lockdep tree? Mind sending it us once you think it's 
>> ready?
> 
> Oh goody, that means you own
> http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
>


That bug got fixed sometime around Dec 2011. See commit e30e2fdf
(VFS: Fix race between CPU hotplug and lglocks)

> I do think the brlock code is sick, but Nick has turned into an ex-Nick
> and nobody works on it.
> 

 
Regards,
Srivatsa S. Bhat

