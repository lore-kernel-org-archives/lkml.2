Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1F3NWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1F3NWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:22:10 -0400
Message-ID: <4E0C7872.9060002@redhat.com>
Date: Thu, 30 Jun 2011 10:21:54 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 2/9] KVM-HDR Add constant to represent KVM MSRs enabled
 bit
References: <1309361388-30163-1-git-send-email-glommer@redhat.com> <1309361388-30163-3-git-send-email-glommer@redhat.com> <20110629215608.GA3557@mgebm.net> <4E0C3458.6090801@redhat.com> <20110630125938.GA4823@mgebm.net>
In-Reply-To: <20110630125938.GA4823@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 09:59 AM, Eric B Munson wrote:
> On Thu, 30 Jun 2011, Avi Kivity wrote:
>
>> On 06/30/2011 12:56 AM, Eric B Munson wrote:
>>> My mail provider seems to have dropped patch 1 of the series so I can't reply
>>> directly to it, please add my Tested-by there as well.
>>
>> How did you test it then?
>>
>
> I built host and guest kernels with the patches and pinned a while(1) and the
> CPU thread from qemu to CPU 2 on the host.  I then started the same while(1)
> process in guest and verified that I see ~50% steal time reported.
>
> I then built 2.6.39 (just the code I had present) on the guest and time it
> while it was competing with the while(1) on the host for CPU time.  Next I
> built the guest kernel with STEAL_TIME=N and reran the kernel compile to make
> sure that there weren't any huge variations in performace.
>
> Eric
I think what Avi means is, it won't even compile without PATCH 1/9. If 
you don't have it, how could you test it ?

