Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1FGVyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:54:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58617 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1FGVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lD7hesGbifzrSq3GQSkfpyw/7OcP66xFH574Rh6Jpw2c6sv5BDNqZjXNcjFLlaf0Tg
         iXBiIt/TkHCXH9d3LDYWrdVtxR/Eb1Phmv84N4gngxlH030UYmnN4rI49zBgfMZydX7u
         H7ADN3UodE92yCQLTQqa/qkuEN6DqGkVvs7jU=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106071855540.4074@ask.diku.dk>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
	<4DEE482D.7020505@cuw.edu>
	<Pine.LNX.4.64.1106071855540.4074@ask.diku.dk>
Date: Tue, 7 Jun 2011 23:54:42 +0200
X-Google-Sender-Auth: 6hDEwF2PlCJsV9_YO8BYq4NoNWs
Message-ID: <BANLkTimMvG332_c4TUPefOJDDE8obowVdQ@mail.gmail.com>
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Julia Lawall <julia@diku.dk>
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>, Gilles.Muller@lip6.fr,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 7, 2011 at 6:56 PM, Julia Lawall <julia@diku.dk> wrote:
>> As an aside, I added a feature to the script for myself so that I can for
>> example write 'make coccicheck M=drivers/net/wireless/' for example to focus
>> in on that directory and just run the checks there... I can submit a patch for
>> this... though I was wondering if there is already a way to do this and I just
>> missed it. The thought was to make it work the same way you'd build a module.
>
> I think it is possible, but Nicolas would know better.
>

I remember me having worked on that but I cannot find any patch
about it so your patch is more that welcome. Some users have requested it
some months ago.

As far as I can remember, with "M=" you can not use $srctree only but still
need it for the -I for instance. I think I then run into a situation where I
have an ambiguity about how to setup the flags for coccinelle, but I am sure
about the reason I dropped my patch. Maybe I don't know well enough the build
system and options...

So, don't hesitate to submit your patch.
Does it also update the Documentation/coccinelle.txt accordingly ?

-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
