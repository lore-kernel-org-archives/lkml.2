Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0EQU33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:29:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21849 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0EQU32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:29:28 -0400
Message-ID: <4BF1A6FA.4090801@oracle.com>
Date: Mon, 17 May 2010 13:28:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: jacob pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/mrst: add more timer config options
References: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>	<1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>	<20100517125619.a0e123cd.randy.dunlap@oracle.com> <20100517132642.000073d4@unknown>
In-Reply-To: <20100517132642.000073d4@unknown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BF1A716.0129:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/10 13:26, jacob pan wrote:
> Randy Dunlap Mon, 17 May 2010 12:56:19 -0700
> 
>>> Manual override is possible via cmdline option x86_mrst_timer.
>>
>> which is documented where??
> It is documented in Documentation/kernel-parameters.txt, the option has not changed but the impact has been extended to the new Medfield platforms.
> 
>         x86_mrst_timer= [X86-32,APBT]
>                         Choose timer option for x86 Moorestown MID platform.
>                         Two valid options are apbt timer only and lapic timer
>                         plus one apbt timer for broadcast timer.
>                         x86_mrst_timer=apbt_only | lapic_and_apbt


Thanks.  I missed seeing that somehow.  Sorry about that.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
