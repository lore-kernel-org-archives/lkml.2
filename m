Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0DNPOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:14:52 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:60985 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0DNPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wiE5Zjhv/dKGM/F/aibAcWbi26I7wLB2Nduzd0Q5QKXygkZ8ViSIFQHSPHs5eTpx+H
         y3M7kYUnMrFv5EPiOTvnJJFBLl286YvNaVm2fsiS1oL2EykMGRj8kg1yHZTP15x36mzS
         G4EkS5k58+F2pwDsduN/gBMbCnLbTpui1gEYw=
Message-ID: <4BC5DC34.2010004@gmail.com>
Date: Wed, 14 Apr 2010 08:16:04 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Tero Roponen <tero.roponen@gmail.com>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, len.brown@intel.com
Subject: Re: [acpi:battery?] kernel oops on boot
References: <20100414095750.GA3304@swordfish.minsk.epam.com> <20100414131324.GA6598@nb-core2.darkstar.lan> <alpine.LFD.2.00.1004141641010.3640@terrop> <4BC5CA13.3070801@suse.de> <alpine.LFD.2.00.1004141704350.1535@terrop>
In-Reply-To: <alpine.LFD.2.00.1004141704350.1535@terrop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 07:05 AM, Tero Roponen wrote:
>
> On Wed, 14 Apr 2010, Alexey Starikovskiy wrote:
>
>> 14.04.2010 17:50, Tero Roponen пишет:
>>>
>>> On Wed, 14 Apr 2010, Luca Tettamanti wrote:
>>>
>>>> Hello,
>>>> I'm seeing a similar bug on my notebook (Asus F3Sa) with current git.
>>>> -rc4 does not work, while -rc3 does work.
>>>>
>>>> The error (at least in my case) is a division by zero in
>>>> acpi_ex_insert_into_field.
>>>
>>> I have a similar problem with Asus M50Vm. git-bisect found
>>> the following commit and reverting it does indeed fix the
>>> problem.
>>>
>>> commit dadf28a10c3eb29421837a2e413ab869ebd9e168
>>> Author: Alexey Starikovskiy<astarikovskiy@suse.de>
>>> Date:   Wed Mar 17 13:14:13 2010 -0400
>>>
>>>       ACPI: EC: Allow multibyte access to EC
>>>
>>>       http://bugzilla.kernel.org/show_bug.cgi?id=14667
>>>
>>>       Signed-off-by: Alexey Starikovskiy<astarikovskiy@suse.de>
>>>       Signed-off-by: Len Brown<len.brown@intel.com>
>>>
>> Please see the patch in https://bugzilla.kernel.org/show_bug.cgi?id=15749
>
> Work for me. Thanks.
>
> Tested-by: Tero Roponen<tero.roponen@gmail.com>


same here(just posted the Oops).
patch works:

Tested-by: Justin P. Mattock <justinmattock@gmail.com>

I actually was getting excited to do a bisect
(I'm a glutton for pain!!).

Justin P. Mattock
