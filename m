Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1BRHRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:17:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61793 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1BRHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:17:48 -0500
Message-ID: <DB2461FECF1749F38B5F6E48D67E5A31@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-4-git-send-email-subhasish@mistralsolutions.com> <4D558337.2060401@mvista.com>
In-Reply-To: <4D558337.2060401@mvista.com>
Subject: Re: [PATCH v2 03/13] da850: pruss board specific additions.
Date: Fri, 18 Feb 2011 12:48:51 +0530
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



--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Saturday, February 12, 2011 12:13 AM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; "open list" 
<linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 03/13] da850: pruss board specific additions.

> Subhasish Ghosh wrote:
>
>> This patch adds board specific initializations and setup routines.
>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> [...]
>
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
>> b/arch/arm/mach-davinci/board-da850-evm.c
>> index 11f986b..242d1ed 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -1053,6 +1053,26 @@ static __init int da850_evm_init_cpufreq(void)
>>  static __init int da850_evm_init_cpufreq(void) { return 0; }
>>  #endif
>>  +static struct da8xx_pruss_devices pruss_devices[] = {
>> + {.dev_name = NULL,},
>
>    No need to explicitly initialize to NULL.
>
SG - Ok, Will remove

> WBR, Sergei
> 
