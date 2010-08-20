Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0HTXAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:00:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53188 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HTXAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hqJtNLwlkPIr8sjchWDGcXkOV8CZykMeHJS5lQ7Ue0cUBt1sllVyV+5D+uqX7W2554
         nIFeahGYzYjqlTnc4GxjOzDAZ3MpvLTUUnyeZFhaW78eX/kQVv0hSeASZtG+7vAS8gUz
         nssD5bq7sOjeQsnAkWSw25AatUixxten1qQlg=
MIME-Version: 1.0
In-Reply-To: <AANLkTin69UwXC3igcLnA9o0P==N2oV55Nj0vJt6WbSDS@mail.gmail.com>
References: <4C4555DA.40203@renesas.com>
	<AANLkTikVm-GWq6vun-AjqLJ1L7Y+s28CdDJqmCEX4+2R@mail.gmail.com>
	<AANLkTinCoSi4s1oNpxptqjA_HEf5Fk92=N_VYNnLR=wF@mail.gmail.com>
	<AANLkTin69UwXC3igcLnA9o0P==N2oV55Nj0vJt6WbSDS@mail.gmail.com>
Date: Sat, 21 Aug 2010 07:59:59 +0900
Message-ID: <AANLkTikbiAJR2-mH_8DSx+WtkjviPHTt2WQ4y0Ut3adG@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Allow 2 byte requests in 4-bit mode
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Yusuke Goda <yusuke.goda.sx@renesas.com>, damm@opensource.se,
        sameo@linux.intel.com, Paul Mundt <lethal@linux-sh.org>,
        g.liakhovetski@gmx.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 5:05 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On 23 July 2010 12:05, Magnus Damm <magnus.damm@gmail.com> wrote:
>>> 2010/7/20 Yusuke Goda <yusuke.goda.sx@renesas.com>:
>>>> Adjust the tmio_mmc block size check to accept 2-byte requests in 4-bit mode.
>>>> Tested with the SDHI hardware block included in sh7724.
>>>>
>>>> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
>>>
>>> With this patch applied I can use SDIO cards in polling mode with the
>>> tmio-mmc driver. Tested with the SDHI hardware block on sh7372 using
>>> the b43 driver and BCM4318 hardware and the unfortunately out-of-tree
>>> AR6002 "android" driver.
>>>
>>> Acked-by: Magnus Damm <damm@opensource.se>
>>>

> On Tue, Jul 27, 2010 at 4:57 PM, Ian Molton <ian@mnementh.co.uk> wrote:
>> This change needs to be modified to test what hardware is present.
>> this wont work on my hardware TTBOMK.
>
> Ok, just curious, on which platform did you test it?
>
> On SDHI hardware the 2-byte access works just fine in 4-bit mode.

Hi Ian,

Any update on this? I'd like to see this patch upstream since it
unbreaks SDIO support for platforms with SDHI controllers.

I have a BCM4318-based SDIO card that I can send with snail mail from
Japan if anyone is interested in testing on non-SDHI platforms.

Thanks,

/ magnus
