Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1JNCss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 22:48:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1JNCsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 22:48:47 -0400
Message-ID: <4E97A307.20208@canonical.com>
Date: Fri, 14 Oct 2011 10:48:39 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com> <1318523759.1913.68.camel@linux-s257.site>
In-Reply-To: <1318523759.1913.68.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joey,

Here you are.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865/+attachment/2330828/+files/AcpiTables.txt


On 10/14/2011 12:35 AM, joeyli wrote:
> Hi Ike, 
> 
> 於 四，2011-10-13 於 14:51 +0800，Ike Panhc 提到：
>> BugLink: http://launchpad.net/bugs/836865
>> BugLink: http://launchpad.net/bugs/826784
>>
>> There are reports say that acer-wmi is loaded on Thinkpad E520 which
>> cause wireless connection hard blocked and we can not unblock it. It
>> will be better not to load acer-wmi on this machine.
>>
>> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>> ---
>>  drivers/platform/x86/acer-wmi.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
>> index af2bb20..dc9a116 100644
>> --- a/drivers/platform/x86/acer-wmi.c
>> +++ b/drivers/platform/x86/acer-wmi.c
>> @@ -325,6 +325,13 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
>>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
>>  		},
>>  	},
>> +	{
>> +		.ident = "Lenovo Thinkpad Edge E520",
>> +		.matches = {
>> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "114320U"),
>> +		},
>> +	},
>>  	{}
>>  };
>>  
> 
> Could you please share Thinkpad edge E520's acpidump and dmidecode log
> to me? 
> Maybe we can capture how does it works with EC register like we support
> Ideapad S205 in acer-wmi driver.
> 
> Add a machine to blacklist is a last resort, I don't want to accept it
> before we try.
> 
> 
> Thank's a lot!
> Joey Lee
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

