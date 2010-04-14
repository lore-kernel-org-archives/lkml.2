Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0DNLRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 07:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab0DNLRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 07:17:38 -0400
Message-ID: <4BC5A43E.1090906@redhat.com>
Date: Wed, 14 Apr 2010 14:17:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <20100414104338.GA31348@elte.hu>
In-Reply-To: <20100414104338.GA31348@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 01:43 PM, Ingo Molnar wrote:
>>
>> Thanks for persisting despite the flames.
>>
>> Can you please separate arch/x86/kvm part of the patch?  That will make for
>> easier reviewing, and will need to go through separate trees.
>>      
> Once it gets into a state that it can be applied could you please create a
> separate, -git based branch for it, so that i can pull it for testing and
> integration with the tools/perf/ bits?
>
>    

Sure.

> Assuming there are no serious conflicts with pending KVM work.
>    

There will be a conflict with the NMI fix (which has to go in first, 
we'll want to backport it), I'll put it on the same branch.

-- 
error compiling committee.c: too many arguments to function

