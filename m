Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0HXA4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0HXA4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:56:43 -0400
Message-ID: <4C7318C0.3030706@redhat.com>
Date: Mon, 23 Aug 2010 14:56:32 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 08/35] Warn about unstable TSC
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-9-git-send-email-zamsden@redhat.com> <20100820172824.GD2937@mothafucka.localdomain>
In-Reply-To: <20100820172824.GD2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:28 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:22PM -1000, Zachary Amsden wrote:
>    
>> If creating an SMP guest with unstable host TSC, issue a warning
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>      
> Ok, I am not sure I agree 100 % this is needed.
> I believe we should try to communicate this kind of thing to the guest,
> not the host, and through cpuid.
>
> Passing through tsc flags to the guest should maybe be enough?
>    

I found a better way to deal with this later in the series... the theory 
being if the full series doesn't get backported to supported releases, 
at least we'll get a warning.
