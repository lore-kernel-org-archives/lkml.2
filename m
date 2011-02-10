Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab1BJFdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:33:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44038 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1BJFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=ngH7ydeXBwWm5gkUb7R/km13tTpGAq27NJP2FKlbtvqDxdW9d5gNb/1HwUOIK7Wlav
         /1GeIp75NGpRnEEJf27BeSxknBf2heEWOOSXR+iHATtZVT4EXfMaN6xxJ4VXRw4R3gIo
         SN5y8Z062O38HjtiLjDoY79PulcYeblJm/14g=
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Message-Id: <B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker like its broken or half plugged in
Date: Wed, 9 Feb 2011 21:33:27 -0800
References: <4D51AD03.7030401@gmail.com> <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com> <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9, 2011, at 2:09 PM, Alex Deucher wrote:

> On Tue, Feb 8, 2011 at 4:20 PM, Alex Deucher <alexdeucher@gmail.com>  
> wrote:
>> On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
>> <justinmattock@gmail.com> wrote:
>>> With the current HEAD Im getting screen flickering really bad to  
>>> point where
>>> it looks like the screen is damaged and/or half plugged-in etc..
>>>
>>> the bisect pointed to here:
>>>
>>> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>>>
>>> doing a git revert 619efb10592
>>> gets the screen working properly again.
>>> I havent looked much through the code to see if I can fix this.  
>>> for the time
>>> being I'll revert this on my machine with the current, until later  
>>> on.
>>
>> The attached patch should fix it assuming I got your pci ids correct.
>> I'm done with the pll stuff; too may fixes break other boards.  Just
>> add a quirk table and be done with it.
>>
>
> The attached patch builds on the previous one and fixes an additional
> regression.
>
> Alex
>
> <0001-drm-radeon-kms-pll-quirk-cleanup.patch>

alright... didn't mean to keep you waiting(out of my office for most  
of the day)..
Anyways patch applied, and everything looks good no screen jitters or  
flickering etc..

Reported-and-Tested-by: Justin P. Mattock<justinmattock@gmail.com>

Thanks for sending this my way so my machine works..

cheers,

Justin P. Mattock
