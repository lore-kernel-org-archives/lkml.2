Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0HCEl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:41:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab0HCElX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=StczKaWqufKZs/WOSnRgIIs8jHDr6O/No2gzHm1jE0X0TDhESpudn+imZei8e1skiy
         LN2GQP+nU5gXArsqxf/4hWgBqI3WMOcFBWGabWpEqZGug+d0UMQzbw0KSk7fn7S0RjIA
         hckEgoKOAd29Z+yAa6tO8qTt5DfY7G+4jHP18=
MIME-Version: 1.0
In-Reply-To: <57767.148.87.67.132.1280784139.squirrel@www.xenotime.net>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
	<1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
	<57767.148.87.67.132.1280784139.squirrel@www.xenotime.net>
Date: Tue, 3 Aug 2010 07:41:21 +0300
Message-ID: <AANLkTimyDwWtLbc682rW-QORjU0+r+txZO-iKAini1H1@mail.gmail.com>
Subject: Re: [PATCH] nconfig: add search support
From: Nir Tzachar <nir.tzachar@gmail.com>
To: rdunlap@xenotime.net
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, trapdoor6@gmail.com, justinmattock@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 12:22 AM,  <rdunlap@xenotime.net> wrote:
> On Sun, August 1, 2010 12:20 am, nir.tzachar@gmail.com wrote:
>> From: Nir Tzachar <nir.tzachar@gmail.com>
>>
>>
>> Remove the old hotkeys feature, and replace by a regular string search.
>> From nconfig help:
>>
>>
>> Pressing '/' triggers search mode. nconfig does regular string match,
>> case insensitive, starting at the begining of each menu line. Pressing
>> Enter highlights the next match, Backspace removes one character from
>> the match string. Pressing either '/' again or ESC exits search mode.
>>
>> Rebind the '/' key (which allowed to search for symbols) to F8
>>
>>
>> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
>> ---
>> scripts/kconfig/nconf.c |  261
>> ++++++++++++++++++++++-------------------------
>> scripts/kconfig/nconf.h |    3 +- 2 files changed, 125 insertions(+), 139
>> deletions(-)
>
>
> A few other comments:
>
> These help text lines should end with a period:
>
>  Pressing SpaceBar toggles between the above options
>
>  <Esc> always leaves the current window
>

Sure.

> The F-key help along the bottom line should be forced to fit
> into 80 columns.  F9 (exit) especially should be visible.

They were, however I think that the symbol search (F-8) kind of ruind
it. I'll shorten its name.

>
> This F3 should be F5:
>
>  Press <Esc>, <F3> or <left-arrow> to go back one menu,

10x.

>
> How about we make nconfig the default in linux-next
> so that it will be used more?

I would love to see that. Let me finalize a patch which properly
supports searching (based on Sam's input) so as to remove the current
upper case ugliness.

Cheers.
