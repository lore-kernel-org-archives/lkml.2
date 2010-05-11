Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0EKAxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:53:22 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:49210 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab0EKAxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vchgggdFrYEAQ/AfcrBM30/Im5KHfOEnH7Iqr9KmATPrqsE9PrY+dEDXD6v4BFc/1L
         ZljAOhWv06T5aBy88Uk595ZEYyr3HCdZSKuRKvwcSqhxNyFc8gjowN4hOxYrqEdYNuL1
         eIaoKb2ELosomVcWAUzVeCHFKFGmcodtjxcOU=
MIME-Version: 1.0
In-Reply-To: <4BE8A70C.4070904@gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <4BE8A477.9080703@gmail.com>
	 <AANLkTiliAXc99ptF15YO8x78SSg8VWVHJg-KUJB7-Ix1@mail.gmail.com>
	 <4BE8A70C.4070904@gmail.com>
Date: Mon, 10 May 2010 20:53:17 -0400
Message-ID: <AANLkTilMt9MCCjkxiom1DGRW_Dvuch9SBcyOwrj-47MA@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 8:38 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 05/10/2010 06:34 PM, Donald Allen wrote:
>>
>> On Mon, May 10, 2010 at 8:27 PM, Robert Hancock<hancockrwd@gmail.com>
>>  wrote:
>>>
>>> On 05/10/2010 06:18 PM, Donald Allen wrote:
>>>>
>>
>>>
>>> Can you post dmesg output from bootup?
>>
>> See attached.
>>
>> /Don Allen
>>>
>
> I don't see anything too abnormal, except this:
>
> ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
>
> I assume your kernel is compiled without SMP support, but you have an Atom
> CPU that supports hyperthreading. I don't know if it's related but you could
> try fixing that and see if it changes anything.

The dmesg (and all other data I supplied) is from the system running
with the custom kernel I built, which has tickless disabled and does
not fail in the way described in the report. So, to be clear, the
dmesg is not from the failing kernel. Unfortunately, it was only after
I'd installed the non-tickless kernel that I was pretty certain of
what was happening and therefore in a position to file a bug report.

Thanks for pointing out the non-smp bug. I'll fix and rebuild my
kernel, but that is not relevant to the tickless issue.

>
