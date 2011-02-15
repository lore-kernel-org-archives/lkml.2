Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1BOSCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:02:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1BOSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:02:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cP26gQM2hVqY7zkbU/Jyf5tf69ZQH1TrK0UDAFgQ4ziJe8LuYlR8DgNwc8Zmr9p2eY
         fNITcuWYFHG49Ci+Cm2XM4XtsuA70ZBy6ONJSqK0JwulqtklBxau8Z6ZOg2/CrHlnDui
         3qd7tIpJc3ZAbfl0LVdJQlzwjqCEg6/d7m93U=
Message-ID: <4D5ABF94.6020001@gmail.com>
Date: Tue, 15 Feb 2011 21:01:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
        brgerst@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization
 from amd_scan_nodes() to amd_numa_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org>	<1297530663-26234-11-git-send-email-tj@kernel.org>	<4D59B3CE.7010408@gmail.com>	<20110215093631.GG3160@htj.dyndns.org>	<4D5AB86A.9030009@gmail.com> <AANLkTi=pmLTRa7K0_E5qXfO2P_+nT3fRXOMDXUpHzK4S@mail.gmail.com>
In-Reply-To: <AANLkTi=pmLTRa7K0_E5qXfO2P_+nT3fRXOMDXUpHzK4S@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 08:54 PM, Yinghai Lu wrote:
...
>
> could just change
>
>   -       if (boot_cpu_physical_apicid>  0) {
>   +       if (boot_cpu_physical_apicid != -1U) {
>                  pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
>                  apicid_base = boot_cpu_physical_apicid;
>          }
>
> Thanks
>
> Yinghai

yup, that is exactly what Tejun suggested in first place ;) I'll update to
this form and add your Acked-by then, ok?

-- 
     Cyrill
