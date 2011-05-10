Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1EJLA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:00:29 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55567 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1EJLA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=P0Suc6Y/es4HgVJYpb0R2W5gmEQmZctVGleq3H0dRONzvVs+s4JVC/4bBP3Z4D+YiC
         fMhBdjqTa0Y7qZgsKYbooladRbZfZrI3eB+JVcu06KbIGcplmCcfGtQPI2ZlNT04iYcq
         qpmmaw/Y5EG8F7ibH0sNFK1XOX2+MCFschor0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1305020267.3206.14.camel@odin>
References: <1304609578.5296.4.camel@phoenix> <1304953437.3192.13.camel@odin>
 <BANLkTintTfzPnYuUtvJuEoAnmjf4_=K=KQ@mail.gmail.com> <1305020267.3206.14.camel@odin>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 10 May 2011 19:00:07 +0800
Message-ID: <BANLkTinyM_ddeJUY8wdf0ruR=6RC0UzBLQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/10 Liam Girdwood <lrg@slimlogic.co.uk>:
> On Tue, 2011-05-10 at 16:54 +0800, Axel Lin wrote:
>> hi Liam,
>>
>> > Applied, Btw is this fix also for 2.6.39 ?
>>
>> I check this patch again and found this actually is not a bug
>> because MC13xxx_DEFINE explictly defines the order of each entry in the array.
>>
>
> :(

Sorry.

>
> I've already pushed this into next, can you send a fix asap.

Do you want me to send a patch to revert the change? ( Though I think
the change is harmless. )
If yes, I can do it.

Regards,
Axel
>
> Thanks
>
> Liam
>
>
