Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3ABEKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 23:10:25 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45205 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3ABEKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:10:23 -0500
Message-ID: <50E3B32A.8070807@lwfinger.net>
Date: Tue, 01 Jan 2013 22:10:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] Fix problem with cpufreq_ondemand or cpufreq_conservative
References: <50DE378D.4090008@lwfinger.net> <CAOh2x==ER3j7P1U+VQEtv00LWWa8JJHu=22--+gTUPFdhiC_cQ@mail.gmail.com>
In-Reply-To: <CAOh2x==ER3j7P1U+VQEtv00LWWa8JJHu=22--+gTUPFdhiC_cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 09:56 PM, Viresh Kumar wrote:
> I know, V4 is already accepted, but i had an small comment with one
> of your earlier change, which doesn't exist anymore :)
>
> On Sat, Dec 29, 2012 at 5:51 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Index: wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
>
> How are you creating these patches? wireless-testing-new (linux directory names)
> aren't supposed to be present here.
>
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/cpufreq/cpufreq_governor.c
>> +++ wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
>> @@ -316,3 +316,8 @@ second_time:
>>          return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(cpufreq_governor_dbs);
>> +
>> +MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
>
> You shouldn't be adding yourself as author here :)
>
> MODULE_AUTHOR("Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>");
> MODULE_AUTHOR("Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>");

I was not adding myself - my name is not Alexander Clouter. When we were 
creating a new module, I got the author from the module that cpufreq_governor 
was originally a part. Perhaps I got the name wrong.

Thanks for the review mentioned in the next Email.

Larry


