Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1ACVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:16:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48811 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1ACVQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=MuLCc6XStW137EAhTXO7yd33w5nwGtUQNhsA7icWNnikcBj3lpMwNbSBQo25FPQnqm
         FryLby8YohY5xhtFVDvxug5WnUNp8qmvJwyozfCzEskMWF2a9hj1HwU+FNzle29DmHLH
         fKgafU+26bSIK20T4wUe1UuebTQhd0sdnxZHw=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110103.115319.245401044.davem@davemloft.net>
References: <1294021724-30337-1-git-send-email-sedat.dilek@gmail.com>
	<20110103.115319.245401044.davem@davemloft.net>
Date: Mon, 3 Jan 2011 22:16:34 +0100
Message-ID: <AANLkTimB3CsS5EVK-KiU9=MfAV9+Gu0=fL4770WKpA0i@mail.gmail.com>
Subject: Re: [PATCH] smsc-ircc2: Fix section mismatch derived from
 smsc_ircc_pnp_driver variable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 8:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Sedat Dilek <sedat.dilek@googlemail.com>
> Date: Mon,  3 Jan 2011 03:28:44 +0100
>
>>>From my build.log:
>>
>> drivers/net/irda/smsc-ircc2.o(.data+0x18): Section mismatch in reference from the variable smsc_ircc_pnp_driver to the function .init.text:smsc_ircc_pnp_probe()
>> The variable smsc_ircc_pnp_driver references
>> the function __init smsc_ircc_pnp_probe()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
>>
>> This patch fixes the warning.
>>
>> Tested with linux-next (next-20101231)
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Just like your other patch, this fix is not correct.
>
> Mark smsc_ircc_pbp_probe() as __devinit instead of __init to fix
> this bug.
>

I have sent a new fixed version.

- Sedat -
