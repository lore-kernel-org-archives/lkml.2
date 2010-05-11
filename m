Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0EKAin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:38:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36267 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0EKAik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FmYu641H4F3T4Z/moLa3lMQKtzHJZOKEwIPQdFOosjKS2RW4DtfFf2m2xR/B7iMmyJ
         Cv8WTGKkKYWkv3Gjg0TzDmxGk8QxEuOhvGrtKWHUUsnlf6PWQZ8i4MJYmVl8Yb1nLmX0
         UF0t4zmK1usuEVOFQRvozq6SBWg/eDDMu443Y=
Message-ID: <4BE8A70C.4070904@gmail.com>
Date: Mon, 10 May 2010 18:38:36 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Donald Allen <donaldcallen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: tickless scheduling
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>	 <4BE8A477.9080703@gmail.com> <AANLkTiliAXc99ptF15YO8x78SSg8VWVHJg-KUJB7-Ix1@mail.gmail.com>
In-Reply-To: <AANLkTiliAXc99ptF15YO8x78SSg8VWVHJg-KUJB7-Ix1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 06:34 PM, Donald Allen wrote:
> On Mon, May 10, 2010 at 8:27 PM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> On 05/10/2010 06:18 PM, Donald Allen wrote:
>>>
>
>>
>> Can you post dmesg output from bootup?
>
> See attached.
>
> /Don Allen
>>

I don't see anything too abnormal, except this:

ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.

I assume your kernel is compiled without SMP support, but you have an 
Atom CPU that supports hyperthreading. I don't know if it's related but 
you could try fixing that and see if it changes anything.
