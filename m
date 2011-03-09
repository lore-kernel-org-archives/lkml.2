Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1CIE1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:27:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35005 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab1CIE1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:27:18 -0500
Message-ID: <54A69D4520F34B0ABD7EFF35DAEFC5DC@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-4-git-send-email-subhasish@mistralsolutions.com> <4D7648FB.9080904@mvista.com>
In-Reply-To: <4D7648FB.9080904@mvista.com>
Subject: Re: [PATCH v3 3/7] da850: pruss board specific additions.
Date: Wed, 9 Mar 2011 09:59:04 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If I don't initialize it to NULL, its getting initialized to some garbage 
string.

--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Tuesday, March 08, 2011 8:49 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; "open 
list" <linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/7] da850: pruss board specific additions.

> Hello.
>
> On 08-03-2011 16:57, Subhasish Ghosh wrote:
>
>> This patch adds board specific initializations and setup routines.
>
>> Signed-off-by: Subhasish Ghosh<subhasish@mistralsolutions.com>
> [...]
>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
>> b/arch/arm/mach-davinci/board-da850-evm.c
>> index 11f986b..c614c82 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -1053,6 +1053,26 @@ static __init int da850_evm_init_cpufreq(void)
>>   static __init int da850_evm_init_cpufreq(void) { return 0; }
>>   #endif
>>
>> +static struct da8xx_pruss_devices pruss_devices[] = {
>> + {.dev_name = NULL,},
>
>    No need to explictly intialize to NULL.
>
> WBR, Sergei 

