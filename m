Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0FFVzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:55:35 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:60698 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0FFVze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rb+KuZIvxyUr+cm512BFdYTxrYNcV3vssAt8SX3+oYpkhw6Fb7A+narVmx7AaJvzJp
         2BX8McxrGqMPqzo1qDu2FPSbnMO0VQWVyvvJ08uMnHc7CHZxlYYgPEJ6VqXaQsfdC2WX
         HfIdGBa9i2nSD5OVDSnO2Bi3nAbWOSd5FHrvo=
MIME-Version: 1.0
In-Reply-To: <201006062104.55869.rjw@sisk.pl>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
	<201006061557.20482.rjw@sisk.pl>
	<1275839650.5331.2.camel@maxim-laptop>
	<201006062104.55869.rjw@sisk.pl>
Date: Sun, 6 Jun 2010 22:55:32 +0100
Message-ID: <AANLkTim9CNFMMVQaghrzK3JnQlGmTewgarT01HP6cEtd@mail.gmail.com>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm for 
	reading & writing a hibernation image.
From: Pedro Ribeiro <pedrib@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2010 20:04, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 06 June 2010, Maxim Levitsky wrote:
>> On Sun, 2010-06-06 at 15:57 +0200, Rafael J. Wysocki wrote:
>> > On Sunday 06 June 2010, Maxim Levitsky wrote:
> ...
>> > So how TuxOnIce helps here?
>> Very simple.
>>
>> With swsusp, I can save 750MB (memory) + 250 Vram (vram)
>> With full memory save I can save (1750 MB of memory) + 250 MB of
>> vram....
>

I am completely unaware of the technical difficulties of saving the
whole memory vs 80% of it, but from my experience with TuxOnIce I
fully agree with Nigel on saving the whole memory.

The fact is that the whole system is much more responsive than when
using swsusp. No doubt about that, I can tell you that TuxOnIce really
changed the way I use my computer. I only used swsusp when I really
needed because of the lagginess starting up, and TuxOnIce changed it.

I have a laptop computer which I have to shutdown every night and open
every morning. It has 4GB of ram and I usually have 3.5 to 3.8 in use
all the time. With TuxOnIce I can restart my work every morning in
under 25 seconds, exactly where I left it, without any delays or
lagginess.

Its kind of hard to express in words, but really, this gave me a
completely different view of how to use a computer. Of course you can
compare it to S2R, but this consumes energy, no matter how little -
this has an environmental and financial cost which will only increase
in the future.

> So what about being able to save 1600 MB total instead of the 2 GB
> (which is what we're talking about in case that's not clear)?  Would it
> be _that_ _much_ worse?

No it wouldn't be much worse. But there will still be some lagginess,
some delay, some sort of annoying disk activity compared to NO delay,
NO lagginess, in short, you have your computer _exactly_ the way you
left it when you left it when you hibernated. And the difference is
noticeable.

>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


Sorry to jump in the thread, but I just wanted to give my end user perspective.

Regards,
Pedro
