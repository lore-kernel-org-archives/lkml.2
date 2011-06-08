Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1FHHLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:11:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35431 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1FHHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tcQOYH13QxIwQv3nGSDCY9L4OV7Xt/2vWBwGD4M/mW0pqDwxIrslhACXLsedO90zTr
         xcB8Rel/Vpgx585cpVLXKQ/q/5HYj1Ar9MwdJG+CQwSm/HK9iArCLCJ6528heyCXIprn
         f+e+1PGV9lPEsg4dfn1rVAz66xFQqk87WuikE=
MIME-Version: 1.0
In-Reply-To: <4DEEAD5D.2090406@cuw.edu>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
	<4DEE482D.7020505@cuw.edu>
	<Pine.LNX.4.64.1106071855540.4074@ask.diku.dk>
	<BANLkTimMvG332_c4TUPefOJDDE8obowVdQ@mail.gmail.com>
	<4DEEAD5D.2090406@cuw.edu>
Date: Wed, 8 Jun 2011 09:11:33 +0200
X-Google-Sender-Auth: SjKU7DHEl-6W1DQkrIb6Ukk3sb8
Message-ID: <BANLkTim-x02kkpcRpPhZEKoJv3YMmQRNOg@mail.gmail.com>
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Julia Lawall <julia@diku.dk>, Gilles.Muller@lip6.fr, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 8, 2011 at 12:59 AM, Greg Dietsche <gregory.dietsche@cuw.edu> wrote:
> On 06/07/2011 04:54 PM, Nicolas Palix wrote:
>>
>> I remember me having worked on that but I cannot find any patch
>> about it so your patch is more that welcome. Some users have requested it
>> some months ago.
>>
>> As far as I can remember, with "M=" you can not use $srctree only but
>> still
>> need it for the -I for instance. I think I then run into a situation where
>> I
>> have an ambiguity about how to setup the flags for coccinelle, but I am
>> sure
>> about the reason I dropped my patch. Maybe I don't know well enough the
>> build
>> system and options...
>>
>> So, don't hesitate to submit your patch.
>>
>
> I'll submit what I have done as a new thread / patch series. I've not done
> much testing with it and am certainly not any kind of build system expert,
> but it has worked well for me so far :) A few more people trying it out /
> testing it would be a great idea.

I finally found the thread where we discuss this feature.
http://lkml.org/lkml/2010/7/2/279

I haven't the time to test your patch right now but at the time
the problem was in the patch mode which produces erroneous file names
(in the lines with ---/+++).
As far as I can remember, using the -dir and -patch options of
coccinelle doesn't work with external modules.



>>
>> Does it also update the Documentation/coccinelle.txt accordingly ?
>>
>
> It will :)
>
> Greg
>
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
