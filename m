Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0FPJo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:44:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0FPJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:44:57 -0400
Message-ID: <4C189CBF.1040701@redhat.com>
Date: Wed, 16 Jun 2010 12:43:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Eric Dumazet <eric.dumazet@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com> <4C187DF1.9030007@zytor.com> <4C188527.9040305@redhat.com> <20100616083941.GA27151@elte.hu> <20100616090155.GK4240@const>
In-Reply-To: <20100616090155.GK4240@const>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:01 PM, Samuel Thibault wrote:
> Ingo Molnar, le Wed 16 Jun 2010 10:39:41 +0200, a écrit :
>    
>> in the long run most processes will be using the FPU due to SIMM
>> instructions.
>>      
> I believe glibc already uses SIMM instructions for e.g. memcpy and
> friends, i.e. basically all applications...
>    

I think they ought to be using 'rep movs' on newer processors, but yes 
you're right.

-- 
error compiling committee.c: too many arguments to function

