Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1BOTlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:41:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45953 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1BOTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:41:38 -0500
Message-ID: <4D5AD6D8.6080101@kernel.org>
Date: Tue, 15 Feb 2011 11:41:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization
 from amd_scan_nodes() to amd_numa_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org>	<1297530663-26234-11-git-send-email-tj@kernel.org>	<4D59B3CE.7010408@gmail.com>	<20110215093631.GG3160@htj.dyndns.org>	<4D5AB86A.9030009@gmail.com> <AANLkTi=pmLTRa7K0_E5qXfO2P_+nT3fRXOMDXUpHzK4S@mail.gmail.com> <4D5ABF94.6020001@gmail.com>
In-Reply-To: <4D5ABF94.6020001@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D5AD6E1.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 10:01 AM, Cyrill Gorcunov wrote:
> On 02/15/2011 08:54 PM, Yinghai Lu wrote:
> ...
>>
>> could just change
>>
>>   -       if (boot_cpu_physical_apicid>  0) {
>>   +       if (boot_cpu_physical_apicid != -1U) {
>>                  pr_info("BSP APIC ID: %02x\n",
>> boot_cpu_physical_apicid);
>>                  apicid_base = boot_cpu_physical_apicid;
>>          }
>>
>> Thanks
>>
>> Yinghai
> 
> yup, that is exactly what Tejun suggested in first place ;) I'll update to
> this form and add your Acked-by then, ok?
> 

yes.

Thanks
