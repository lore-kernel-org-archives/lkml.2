Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1ACVXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:23:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38913 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1ACVXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=bZEtauUp4+KFxuFL2R3Zyfje9sPxyf3JKwX3WsW74GXDu7Q4LA8YZ97imZMev/hR5F
         1slD+2JNSlvj+cVgC8xNnW6EDo1KQn09bhm46DbXsyc5hxsK7Zz+tZHMyAPTL9gAHu9k
         vG3mM3fNZUEBRm2mn2nCB+drt5IGljlwH70k4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110103.115336.70200097.davem@davemloft.net>
References: <1294021987-30385-1-git-send-email-sedat.dilek@gmail.com>
	<20110103.115336.70200097.davem@davemloft.net>
Date: Mon, 3 Jan 2011 22:23:03 +0100
Message-ID: <AANLkTikZh4qZgDjJPbX=iSKKfU+mcNE87nd4vO_p1euV@mail.gmail.com>
Subject: Re: [PATCH] depca: Fix section mismatch derived from depca_isa_driver variable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 8:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Sedat Dilek <sedat.dilek@googlemail.com>
> Date: Mon,  3 Jan 2011 03:33:07 +0100
>
>>>From my build.log:
>>
>> WARNING: drivers/net/depca.o(.data+0x0): Section mismatch in reference from the variable depca_isa_driver to the function .init.text:depca_isa_probe()
>> The variable depca_isa_driver references
>> the function __init depca_isa_probe()
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
> Again, mark depca_isa_probe() as __devinit to fix this bug.
>

Thanks for the pointer, I have sent a new fixed version.

- Sedat -
