Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0GLO2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:28:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0GLO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C6eApwNumLvQOoOysnoAmzVyvGvKRxASdtC2mIfYnQ7w7OrAijpk1oDNfO9jQKoRWR
         kZ5vvJ9Ipgwj6LwQXkCIfFGHxDg4MGNbj8sAr8Oq3KEmUk6VliG1BVdKF3SNJjusRNst
         g2kyaFfFNvnzAg0Q9UjCKv8GC7/d4qsLChcLQ=
MIME-Version: 1.0
In-Reply-To: <20100703212015.GA32052@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
	<20100701162454.GD4152@core.coreip.homeip.net>
	<AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
	<AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
	<20100701224235.GA29504@core.coreip.homeip.net>
	<AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
	<20100703212015.GA32052@core.coreip.homeip.net>
Date: Mon, 12 Jul 2010 16:28:41 +0200
Message-ID: <AANLkTimYUdjdT4YAX4yHmJEDB0yeYmx3YGTMqQ7Pdp79@mail.gmail.com>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active 
	multiplexor, mouse won't work.)
From: Jerome Lacoste <jerome.lacoste@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 3, 2010 at 11:20 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
[...]
>> > Could you please also try i8042.reset instead of i8042.nomux?
>>
>> the i8042.reset works so far after 5 resumes.
>>
>> Tested with: Linux expresso2 2.6.32-23-generic #37-Ubuntu SMP Fri Jun
>> 11 07:54:58 UTC 2010 i686 GNU/Linux
>>
>> Should I test something else ?
>>
>
> Coudl you please try the patch below?
>
> Thanks.

Patch works ( I adapted it to work for my kernel:
http://launchpadlibrarian.net/51784930/0001-Input-i8042-reset-keyboard-controller-wehen-resuming.patch
)

Sorry it took me quite a bit of time to manage to get Ubuntu's git
repo cloned and build my kernel.

I suspended/resumed 3 times so far after removing the i8042.quiet
option. There's nothing wrong in the logs. I'll report if I see a
problem.

I haven't noticed delays in resuming.

Jerome
