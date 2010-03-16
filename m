Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937818Ab0CPLKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 07:10:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937777Ab0CPLKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:10:39 -0400
Message-ID: <4B9F671D.5060001@redhat.com>
Date: Tue, 16 Mar 2010 13:10:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4B9F19F7.6000309@redhat.com> <20100316072449.GB11881@elte.hu> <4B9F4D74.4090403@redhat.com> <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu>
In-Reply-To: <20100316105021.GA14344@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 12:50 PM, Ingo Molnar wrote:
>
>> I'm confused - initrd seems to be guest-side.  I was talking about the host
>> side.
>>      
> host side doesnt need much support - just some client capability in perf
> itself. I suspect vmchannels are sufficiently flexible and configuration-free
> for such purposes? (i.e. like a filesystem in essence)
>    

I haven't followed vmchannel closely, but I think it is.  vmchannel is 
terminated in qemu on the host side, not in the host kernel.  So perf 
would need to connect to qemu.

-- 
error compiling committee.c: too many arguments to function

