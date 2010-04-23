Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0DWVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541Ab0DWVlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:41:23 -0400
Message-ID: <4BD213FE.2000800@redhat.com>
Date: Fri, 23 Apr 2010 11:41:18 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271675100.1674.818.camel@laptop> <4BCC3A3E.9070909@redhat.com> <20100419142158.GD14158@mothafucka.localdomain> <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org> <4BCDF85C.3000004@redhat.com> <4BCE0399.2010708@goop.org> <20100422131113.GA3364@mothafucka.localdomain> <4BD0FB92.4060301@redhat.com> <4BD169B5.4000409@redhat.com> <4BD211B9.5080707@redhat.com> <4BD212BF.60707@goop.org>
In-Reply-To: <4BD212BF.60707@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 11:35 AM, Jeremy Fitzhardinge wrote:
> On 04/23/2010 02:31 PM, Zachary Amsden wrote:
>    
>> Does lfence / mfence actually serialize?  I thought there was some
>> great confusion about that not being the case on all AMD processors,
>> and possibly not at all on Intel.
>>
>> A trap, however is a great way to serialize.
>>
>> I think, there is no serializing instruction which can be used from
>> userspace which does not trap, at least, I don't know one off the top
>> of my head.
>>      
> rsm is not technically privileged... but not quite usable from usermode ;)
>    

rsm under hardware virtualization makes my head hurt
