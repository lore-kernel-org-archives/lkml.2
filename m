Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1FTQos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:44:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52327 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1FTQor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CAhVAkSWQRncFnIqstf3eOep6+f+3+PLIVKwSqC7NvlO8nu247tSz3Swxs8/IQBnZX
         b5lG95AZdvcQMolAlDeToXCFbcj9BiiQcC6wCBWLjYZZjudeSvwJaD1hsfKY3E7UzWl+
         9oUSXlZphczLC991s4u42oyCAcHKatLiXGbHA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106201608460.11049@pobox.suse.cz>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
	<4DFF1AA5.80508@ru.mvista.com>
	<alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
	<1308566964.13261.14.camel@vivanov>
	<alpine.LNX.2.00.1106201608460.11049@pobox.suse.cz>
Date: Mon, 20 Jun 2011 19:44:46 +0300
Message-ID: <BANLkTimfWxPm6EC9PZvqaqELz1gf-0iVLA@mail.gmail.com>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h include
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>, Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 5:09 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 20 Jun 2011, Vitaliy Ivanov wrote:
>
>> Giri,
>>
>> I would still recommend to use the following patch as it corrects many
>> other places for trivial includes duplication. Also I was the first who
>> sent it:).
>
> Unfortunately I haven't been copied on it.
>
>> --
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>>
>> Many stupid corrections of duplicated includes based on the output of scripts/checkincludes.pl.
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>
> I have applied it, and after performing build tests I will be pushing it
> out.

Thanks Jiri. Can see it in your tree already. The patch itself is
absolutely harmless except of one non usual correction to
cyashalomap_kernel.h.

- Vitaliy
