Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab0DHTBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:01:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58104 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab0DHTB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YiEZv/AGlt/Y64Ld+uuosHXk5+C8NX0cS5Arzb7pJirJtnVs/WZTd1sSmnyOXGrqHk
         mVwHAuUBrOHLnS3Wv6JU/fCW7y6SE9WImHw3HlozCuy+Fd22baL9XEDv+nwhwEmJ7JkK
         //WWdVSoOycisCf4jlHCGsYyiNemrSR9+UudU=
MIME-Version: 1.0
In-Reply-To: <k2t51f3faa71004081040l326458e4zf89854ec32a57940@mail.gmail.com>
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>
	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
	 <4BBD1957.90502@gmail.com>
	 <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com>
	 <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>
	 <4BBD7997.1020803@ladisch.de>
	 <l2v5bdc1c8b1004080753k7787e635p4a70d4a1a777984d@mail.gmail.com>
	 <4BBDEF93.6070306@ladisch.de>
	 <z2i5bdc1c8b1004080924q1b8d3994vd69c9c9dd0bb2f78@mail.gmail.com>
	 <k2t51f3faa71004081040l326458e4zf89854ec32a57940@mail.gmail.com>
Date: Thu, 8 Apr 2010 12:01:28 -0700
Message-ID: <j2s5bdc1c8b1004081201odd560a13z3a00c5c2325b4293@mail.gmail.com>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype 
	failed -22
From: Mark Knecht <markknecht@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 10:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Thu, Apr 8, 2010 at 10:24 AM, Mark Knecht <markknecht@gmail.com> wrote:
>> On Thu, Apr 8, 2010 at 8:00 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
>>> Mark Knecht wrote:
>>>> ioremap reserve_memtype failed -22
>>>> phys_addr: 0xcf7fe000, size: 0x2000
>>>
>>> What is at this address in /proc/iomem?
>>>
>>>> Call Trace:
>>>>  [<ffffffff8101b7ee>] ? __ioremap_caller+0x1e2/0x30e
>>>>  [<ffffffffa052345b>] ? _nv006553rm+0x3a/0x40 [nvidia]
>>>
>>> I didn't find this function name in the kernel source ...
>>>
>>>
>>> Regards,
>>> Clemens
>>>
>>
>> Is there a serious chance this is somehow related to the closed source
>> nvidia driver? I could investigate switching to the in kernel driver
>> although that might take me a little time to get to.
>
> Yeah, those symbols are from the NVIDIA driver. Seems like it's trying
> to reserve part of memory in ACPI tables somehow?
>
> You might want to make sure you have the latest version (or just use
> nouveau instead..)
>

I spent a few minutes looking at the Gentoo nouveau guide. I think I
won't be able to do that before Sunday so if there's nothing else to
reasonably look at and you're >50% sure that's the reason then I'll
probably have to get back to you guys next Monday or so. (Assuming the
guides are correct and it actually works.

One question: If I simply remove the nvidia driver (either emerge -C
or blacklist it) then assuming it doesn't load if I don't see the
message we at least know it's involved in the problem, correct? That's
very easy to do right now as a test.

- Mark
