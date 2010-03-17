Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0CQKHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0CQKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:07:10 -0400
Message-ID: <4BA0A9B8.1030802@redhat.com>
Date: Wed, 17 Mar 2010 12:06:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <201003171728.43739.sheng@linux.intel.com> <4BA0A3E6.4040100@redhat.com> <201003171751.01777.sheng@linux.intel.com>
In-Reply-To: <201003171751.01777.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 11:51 AM, Sheng Yang wrote:
>
>> I think you need DM_NMI for that to work correctly.
>>
>> An alternative is to call the NMI handler directly.
>>      
> apic_send_IPI_self() already took care of APIC_DM_NMI.
>    

So it does (though not for x2apic?).  I don't see why it doesn't work.

> And NMI handler would block the following NMI?
>
>    

It wouldn't - won't work without extensive changes.

-- 
error compiling committee.c: too many arguments to function

