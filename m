Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2EXDJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:09:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58783 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2EXDI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com>
References: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com>
	<alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com>
Date: Thu, 24 May 2012 11:08:58 +0800
Message-ID: <CABawtvM-ZzFvT3LLb5V2bm52odeSyxeQwwvbVXgrNcMX5WMrbQ@mail.gmail.com>
Subject: Re: ACPI and NUMA guys, please help to check if this patch is OK
From: ethan zhao <ethan.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Kurt Garloff <kurt@garloff.de>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
    What we can do to help improving Linux OS is only about fatal
error ? Can I do something to give more clear warning information and
easy to find the root cause ?

Thanks,
Ethan

On Wed, May 23, 2012 at 11:30 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 23 May 2012, ethan zhao wrote:
>
>> [PATCH] drivers/acpi/numa.c: Add localities checking code against
>> proximity domains to slit_valid()
>>
>>  Some buggy BIOS/ACPI will set different number to SLIT localities and
>> SRAT proximity domains,
>>  That will make NUMA configuration invalid and kernel will output
>> information like following
>>
>> NUMA:Warning:invalid distance parameter, from=-1 to=-1 distance=83
>>
>> This patch adds some checking code to slit_valid() function in order
>> to check theSLIT localities
>> count against SRAT proximity domains number and give clear information
>> about ACPI bug.
>>
>> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>
> There's nothing in the ACPI spec that prohibits this and the result is
> non-fatal (it only emits a warning of the mismatch), so this patch is
> unnecessary.
