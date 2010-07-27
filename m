Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0G0IFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:05:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35352 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0G0IFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c09va4waWoVT2s+OXG8uDSmO4at0doZkxbLnZ/4WvbG9K1voY7MhGpZ5/LATX9b5Wi
         zxiv5D2RHm45smqWeL/IVmv6aHP5v48N9YtVX7KZlXBuWeurC+D0hCpdKa+BNEZncnL3
         RpIEAFWmTsLZWZqrFdMdk5pwXvKsaLME31c90=
MIME-Version: 1.0
In-Reply-To: <AANLkTinCoSi4s1oNpxptqjA_HEf5Fk92=N_VYNnLR=wF@mail.gmail.com>
References: <4C4555DA.40203@renesas.com>
	<AANLkTikVm-GWq6vun-AjqLJ1L7Y+s28CdDJqmCEX4+2R@mail.gmail.com>
	<AANLkTinCoSi4s1oNpxptqjA_HEf5Fk92=N_VYNnLR=wF@mail.gmail.com>
Date: Tue, 27 Jul 2010 17:05:33 +0900
Message-ID: <AANLkTin69UwXC3igcLnA9o0P==N2oV55Nj0vJt6WbSDS@mail.gmail.com>
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

> On 23 July 2010 12:05, Magnus Damm <magnus.damm@gmail.com> wrote:
>> 2010/7/20 Yusuke Goda <yusuke.goda.sx@renesas.com>:
>>> Adjust the tmio_mmc block size check to accept 2-byte requests in 4-bit mode.
>>> Tested with the SDHI hardware block included in sh7724.
>>>
>>> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
>>
>> With this patch applied I can use SDIO cards in polling mode with the
>> tmio-mmc driver. Tested with the SDHI hardware block on sh7372 using
>> the b43 driver and BCM4318 hardware and the unfortunately out-of-tree
>> AR6002 "android" driver.
>>
>> Acked-by: Magnus Damm <damm@opensource.se>
>>

Hi Ian,

Thanks for your feedback!

On Tue, Jul 27, 2010 at 4:57 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> This change needs to be modified to test what hardware is present.
> this wont work on my hardware TTBOMK.

Ok, just curious, on which platform did you test it?

On SDHI hardware the 2-byte access works just fine in 4-bit mode.

Thanks,

/ magnus
