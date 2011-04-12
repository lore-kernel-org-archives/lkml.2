Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1DLUSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:18:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64498 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1DLUSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R8PwvBb8NhmxCjO9Ha0GE4O7/LbkQep2Jqx3j0JCWbWFXWvJQSIEXuavHn1lIYVGjE
         0Kmwu+vZYhI/F3lYL0GaX8msciCCL3bgdD/jPGDEXFmg5PuFTNVo34joc1OYSEx/EqwG
         MLpjzKHn6exbDmDAgbSWd/uNiUTS4y9apkbD0=
MIME-Version: 1.0
In-Reply-To: <BANLkTik0WzoBig5tfefkEEaWc-xaXQDq9Q@mail.gmail.com>
References: <4D90CBE5.6090706@kernel.org>
	<20110412091145.2bc5e6a9@jbarnes-desktop>
	<4DA489F0.4000003@kernel.org>
	<20110412104716.5388849d@jbarnes-desktop>
	<4DA491C6.90403@kernel.org>
	<20110412105827.443bd56e@jbarnes-desktop>
	<BANLkTik0WzoBig5tfefkEEaWc-xaXQDq9Q@mail.gmail.com>
Date: Tue, 12 Apr 2011 13:18:45 -0700
X-Google-Sender-Auth: TzMPYTrIR2sIJL-8_wzaNaQIyXM
Message-ID: <BANLkTin+ytTv3zSMdPSgSXuT8NqQ1ExszQ@mail.gmail.com>
Subject: Re: [PATCH -v2] x86: Remove dma32_reserve_bootmem
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Apr 12, 2011 at 10:58 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Tue, 12 Apr 2011 10:54:14 -0700
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On 04/12/2011 10:47 AM, Jesse Barnes wrote:
>>> > On Tue, 12 Apr 2011 10:20:48 -0700
>>> > Yinghai Lu<yinghai@kernel.org>  wrote:
>>> >
>>> >>
>>> >> That is workaround for holding dma32 buf when early bootmem could use up
>>> >> those range on system that have lots of RAM.
>>> >>
>>> >> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
>>> >>
>>> >> So We could remove those not needed code now.
>>> >>
>>> >> -v2: rebase on pci-next
>>> >>
>>> >> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>>> >>
>>> >
>>> > Hm, still didn't apply cleanly, I guess the patch got corrupted.  I
>>> > fixed it up by hand and applied to linux-next though, thanks.
>>>
>>> sorry for that. looks like recent thunderbird upgrade convert TAB to space..
>>
>> Thanks for checking.  I wonder why every mailer (and some MTAs!) feel
>> the need to molest message content so thoroughly...
>>
>
> looks like patchwork and LKML have tab instead of spaces.
>
> https://patchwork.kernel.org/patch/701342/
>
> https://lkml.org/lkml/2011/4/12/358
>
> also it is very interesting: in thunderbox inbox/send box, some mails
> are viewed with TAB as spaces.
> but source does have TAB.
>

while using thunderbird 3.1.8 to send patch, need to set

mailnews.send_plaintext_flowed

to false.

otherwise viewer could show TAB as spaces.

Yinghai
