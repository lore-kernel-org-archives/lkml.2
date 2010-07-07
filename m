Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0GGOOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab0GGOOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:14:31 -0400
Message-ID: <4C348BA8.9030206@redhat.com>
Date: Wed, 07 Jul 2010 17:14:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: KVM, fix lock imbalance
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com> <20100707130545.GA14934@elte.hu> <4C347C0E.6020107@gmail.com> <4C347F3C.2010704@redhat.com> <20100707141008.GA7419@elte.hu>
In-Reply-To: <20100707141008.GA7419@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 05:10 PM, Ingo Molnar wrote:
>
>> In any case, the patch is a minimal fix, so I'll apply it.  Any clean ups
>> can go on top.
>>      
> The reason the pattern caught my attention is that it is one of the typical
> cases where goto labels help prevent similar bugs. I.e. had it been clean to
> begin with the bug might not have happened.
>    

Agreed.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

