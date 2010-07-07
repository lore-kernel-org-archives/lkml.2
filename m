Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0GGNVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab0GGNVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:21:48 -0400
Message-ID: <4C347F3C.2010704@redhat.com>
Date: Wed, 07 Jul 2010 16:21:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: KVM, fix lock imbalance
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com> <20100707130545.GA14934@elte.hu> <4C347C0E.6020107@gmail.com>
In-Reply-To: <4C347C0E.6020107@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 04:07 PM, Jiri Slaby wrote:
>
>> A cleanliness comment: why is that tear-down/dealloc sequence open-coded? It
>> should be at the end of the function, with goto labels, like we do it in
>> similar cases.
>>      
> Because the lock is around a block only. I usually don't create a goto
> fail-paths in these cases. Do you want one?
>    

In any case, the patch is a minimal fix, so I'll apply it.  Any clean 
ups can go on top.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

