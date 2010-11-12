Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0KLMmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:42:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64194 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0KLMmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W2HK+5YFbbmNsi0bromETuY9iu5LswGXbeDQPrtnIb550ENdEK+HuQb8P0l4GiWA3k
         s90J/u1zFxitHnCyJTjvGX6iu+ugysTHeAH3hcO6cOUvqf1JewFUI10kraSaiFxnuGQN
         7f1/kA4w9f1AG6Bvarlt3+PMxaQWZAdWRVKgo=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=6qNSOuHxzbLjUAcg=Mn-ucO8KRZreiVQ9PAkM@mail.gmail.com>
References: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<AANLkTimd4AruJa2BvqOFw-aP9VpHubsx5Xrwkma+Um5X@mail.gmail.com>
	<AANLkTi=6qNSOuHxzbLjUAcg=Mn-ucO8KRZreiVQ9PAkM@mail.gmail.com>
Date: Fri, 12 Nov 2010 18:12:34 +0530
Message-ID: <AANLkTinO176o81bZCmt+c4OW6j3Yb9zMRTy8vJuHoE0E@mail.gmail.com>
Subject: Re: [PATCHv3 0/4] OMAP: Serial: remove magic and diplicates
From: Govindraj <govindraj.ti@gmail.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 5:55 PM, Andrei Emeltchenko
<andrei.emeltchenko.news@gmail.com> wrote:
> On Fri, Nov 12, 2010 at 1:34 PM, Govindraj <govindraj.ti@gmail.com> wrote:
>> Looks fine to me.
>>
>> I think you need to CC this patch series to
>> arm list and serial list as well.
>
> Govindraj, Do I need to resend the patch including arm and serial MLs?

yes, probably after incorporating manjunath's comments.

--
Govindraj.R

>
> Regards,
> Andrei
>
>>
>> Thanks,
>> Govindraj.R
>>
>>
>> On Fri, Nov 12, 2010 at 2:51 PM, Emeltchenko Andrei
>> <Andrei.Emeltchenko.news@gmail.com> wrote:
>>> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>>>
>>> Add MDR1 Serial register definition to serial_reg and remove duplicated
>>> code.
>>> *v2 add OMAP keyword to MDR1 definition
>>> *v3 remove magic from serial drivers
>>>
>>> Andrei Emeltchenko (4):
>>>  OMAP: Serial: Define OMAP uart MDR1 register definitions
>>>  OMAP1: Serial: remobe magic from MDR1 register
>>>  OMAP2: Serial: remobe magic from MDR1 register
>>>  OMAP: Serial: remove redefined MDR1 register definitions
>>>
>>>  arch/arm/mach-omap1/serial.c                  |    6 ++++--
>>>  arch/arm/mach-omap2/serial.c                  |   15 +++++++++------
>>>  arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
>>>  drivers/serial/omap-serial.c                  |    6 +++---
>>>  include/linux/serial_reg.h                    |   12 ++++++++++++
>>>  5 files changed, 28 insertions(+), 14 deletions(-)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>
