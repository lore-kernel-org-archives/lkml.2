Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0G0H6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:58:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63310 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0G0H6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=GbgLbfRhldBHVlmQuPBb9iaq7/VSFdHmgMRds4HBVMn8poR970QTwu1T8FPW0/L6Nk
         MxuLeN6Evvcy4FGzsudJkOPazApSycbQJttHH63YswiNs3G4TUeprrF7X5+sPHlOucoB
         RXwSF/YJJsvkeB0GuOipuMjxEwmpCatnt0KRw=
MIME-Version: 1.0
In-Reply-To: <AANLkTikVm-GWq6vun-AjqLJ1L7Y+s28CdDJqmCEX4+2R@mail.gmail.com>
References: <4C4555DA.40203@renesas.com> <AANLkTikVm-GWq6vun-AjqLJ1L7Y+s28CdDJqmCEX4+2R@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Date: Tue, 27 Jul 2010 08:57:40 +0100
X-Google-Sender-Auth: m_YoVKBq2ZlTeobgKa0iX2bHdwc
Message-ID: <AANLkTinCoSi4s1oNpxptqjA_HEf5Fk92=N_VYNnLR=wF@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Allow 2 byte requests in 4-bit mode
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Yusuke Goda <yusuke.goda.sx@renesas.com>, damm@opensource.se,
        sameo@linux.intel.com, Paul Mundt <lethal@linux-sh.org>,
        g.liakhovetski@gmx.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change needs to be modified to test what hardware is present.
this wont work on my hardware TTBOMK.

-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/



On 23 July 2010 12:05, Magnus Damm <magnus.damm@gmail.com> wrote:
> 2010/7/20 Yusuke Goda <yusuke.goda.sx@renesas.com>:
>> Adjust the tmio_mmc block size check to accept 2-byte requests in 4-bit mode.
>> Tested with the SDHI hardware block included in sh7724.
>>
>> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
>
> With this patch applied I can use SDIO cards in polling mode with the
> tmio-mmc driver. Tested with the SDHI hardware block on sh7372 using
> the b43 driver and BCM4318 hardware and the unfortunately out-of-tree
> AR6002 "android" driver.
>
> Acked-by: Magnus Damm <damm@opensource.se>
>
