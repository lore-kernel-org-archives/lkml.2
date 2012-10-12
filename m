Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2JLK7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:59:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2JLK7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:59:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5990074"
Message-ID: <5077F7BA.50905@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 18:58:02 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: yinghai@kernel.org, lenb@kernel.org, bhelgaas@google.com,
        izumi.taku@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Do not use acpi_device to find pci root bridge in
 _init code.
References: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com> <1350037890-5899-3-git-send-email-tangchen@cn.fujitsu.com> <5077F2C2.1010300@huawei.com> <5077F407.3040205@cn.fujitsu.com> <5077F6E1.7090600@huawei.com>
In-Reply-To: <5077F6E1.7090600@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:58:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:58:58,
	Serialize complete at 2012/10/12 18:58:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 06:54 PM, Jiang Liu wrote:
>>> I have sent a similar patch to Yinghai before. For simplicity, we could
>>> use acpi_match_object_info_ids() instead of acpi_match_device_ids()
>>> directly.
>>
>> Hum, I must have missed it. :)
>> Using acpi_match_object_info_ids() directly seems good. I'm just worry
>> about if it could cause any other problem. :)
>>
>> So now, is this bug fixed ? And we don't need these patches, right ?
>>
>> Thanks. :)
> I think Yinghai has missed my patch too, so just suggest to use
> acpi_match_object_info_ids() directly.

OK. :)

I will resend a new patch set soon. Thanks for your advice. :)

>
> --Gerry
>
>>
>>> Thanks!
>>> Gerry
>>>
>>>>
>>>>        ret = acpi_match_device_ids(device, root_device_ids);
>>>>        if (ret)
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> .
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

