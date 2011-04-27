Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1D0Gmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:42:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51874 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1D0Gmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:42:36 -0400
Message-ID: <0A4FA4CFE83C4DD4BA36491027E93552@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Kevin Hilman \(supporter:TI DAVINCI MACHIN...,commit_signer:15/17=88%\)" 
	<khilman@ti.com>,
        "Russell King \(maintainer:ARM PORT\)" <linux@arm.linux.org.uk>,
        "Michael Williamson \(commit_signer:6/17=35%\)" 
	<michael.williamson@criticallink.com>,
        "Cyril Chemparathy \(commit_signer:3/17=18%\)" <cyril@ti.com>,
        "Sergei Shtylyov \(commit_signer:2/17=12%\)" 
	<sshtylyov@ru.mvista.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-4-git-send-email-subhasish@mistralsolutions.com> <4DB6A736.3030609@mvista.com>
In-Reply-To: <4DB6A736.3030609@mvista.com>
Subject: Re: [PATCH v4 03/11] da850: pruss platform specific additions.
Date: Wed, 27 Apr 2011 12:13:12 +0530
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


>>   #include<mach/edma.h>
>> @@ -73,6 +75,7 @@ extern unsigned int da850_max_speed;
>>   #define DA8XX_DDR2_CTL_BASE 0xb0000000
>>   #define DA8XX_ARM_RAM_BASE 0xffff0000
>>   #define DA8XX_SHARED_RAM_BASE 0x80000000
>> +#define DA8XX_PRUSS_MEM_BASE 0x01C30000
>
>    Keep the list sorted please. Also, this macro doesn't seem used outside 
> devices-da8xx.c, so should be moved there...

SG - But would it not be better to have all device addresses at the same 
place.
 

