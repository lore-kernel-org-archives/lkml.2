Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0CSHX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0CSHX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:23:26 -0400
Message-ID: <4BA32645.3020500@redhat.com>
Date: Fri, 19 Mar 2010 09:22:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, drepper@gmail.com,
       Anthony Liguori <anthony@codemonkey.ws>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318201826.GA20588@elte.hu> <g6y0y1gaeew5bcwbUYAxe124vaj_firegpg@mail.gmail.com> <20100318205655.GB4821@elte.hu> <20100318220654.4305b9e0@lxorguk.ukuu.org.uk> <20100318221617.GB19669@elte.hu>
In-Reply-To: <20100318221617.GB19669@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 12:16 AM, Ingo Molnar wrote:
>
>> Yes its a double standard
>>
>> Glibc has a higher standard than Fedora/RHEL.
>>
>> Just like the Ubuntu kernel ships various ugly unfit for upstream kernel
>> drivers.
>>      
> There's a world of a difference between a fugly driver and a glibc patch.
>
>    

Yes, fugly drivers can be cleaned up, but glibc ABIs are forever.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

