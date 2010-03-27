Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab0C0BsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:48:00 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:50146 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0C0Br7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GHU7jbX1k06n82Iiz5owINQOadubrB4G2YWvBu+b5o3wBKb+Q0cgBaAi4XrXf/uDpZ
         VvN821TJq8+LUSW1t12IvMNzMIvLdpea+zwELcK630P9MOPsGN0wuoKEHVHSCg8GJcHg
         /WdBNV6BKLCUBLPlnu55/18Mflhp1Ldeu8qOo=
Message-ID: <4BAD63C8.6070401@gmail.com>
Date: Fri, 26 Mar 2010 19:47:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arnout Vandecappelle <arnout@mind.be>
CC: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: how to debug a kernel that does not power off?
References: <4BA9525E.9000701@maroy.hu> <201003262056.11231.arnout@mind.be>
In-Reply-To: <201003262056.11231.arnout@mind.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 01:56 PM, Arnout Vandecappelle wrote:
>   Take a look at the pm_power_off functions in arch/x86/kernel/apm_32.c
>
>   Regards,
>   Arnout

Any modern machine will be using ACPI functions to power off, not APM.. 
CCing the linux-acpi list.

>
> On Wednesday 24 March 2010 00:44:30, Ákos Maróy wrote:
>> Hi,
>>
>> This might be a lame question, but: how would I debug a kernel that
>> simply does not power off a machine? When powering off, on the console I
>> get to the message: [...] Poweroff.
>>
>> but then, the machine actually does not power off. This is an HP Envy 15
>> laptop using an intel i7 CPU, and kernel 2.6.32.9.
>>
>> I tried to read up on all sorts of documentation, but could not get more
>> debug info out of the kernel :(
>>
>> any pointers would be welcome..
>>
>>
>> Akos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

