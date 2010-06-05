Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0FEIg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 04:36:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58011 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab0FEIgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 04:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VHWO0hvu3aCT9Q+w/iaeL10oMuD3x1+Afh16pYN9kpJVhS2o0zTB15qkwAfsmzoems
         DQWZZUwxw02DY2G6Vycd9TB4uyZ3N6i+thRoAqt6UWQRmisDAkT1cpXuvMZiLQvMtWQX
         YBBhUjmjsMqC3xoHbw7gPsSfpbpLbVaaLJzoU=
MIME-Version: 1.0
In-Reply-To: <4C0A0AB6.20206@cs.helsinki.fi>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
	<1275379286-10453-2-git-send-email-ngupta@vflare.org>
	<AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
	<20100604121957.d9bc55ae.akpm@linux-foundation.org>
	<4C0A0AB6.20206@cs.helsinki.fi>
Date: Sat, 5 Jun 2010 11:36:53 +0300
X-Google-Sender-Auth: HLW0FzptvoWYLWnbU-oiTyl_IyE
Message-ID: <AANLkTimALH7n_6CiG2W5GBLPAw8-xkxvm5Auzj9pmErA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support generic I/O requests
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Nitin Gupta <ngupta@vflare.org>,
       Greg KH <greg@kroah.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 11:28 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Andrew Morton wrote:
>>>
>>> I thought zram is related to memory management a little bit.
>>>
>>> What's the criteria?
>>
>> Yes, and this is something which bothers me a bit about the -staging
>> process.  Code gets in there largely under the radar of the people who
>> work in that area.  It gets "matured" for a while and the developer
>> thinks it's all ready to go into "mainline" and ....  then what? Someone
>> needs to yank the code out of -staging and tell the interested
>> parties "hey, look at this".  And at this stage, they might say "hell
>> no", or request large changes and the developer who thought everything
>> was all ready to go would be justifiably upset.
>
> Yeah, that's what I assumed would happen here. When the code in -staging is
> "good enough", Nitin would submit squashed patches for inclusion review and
> when everyone is happy, we'd merge the code including full history from
> -staging.
>
> Btw, ramzswap and zram have been discussed openly on LKML. I guess Nitin
> should have CC'd linux-mm as well for you to see it Andrew?

Sorry for the duplicate mail. I thought I lost this to /dev/null.
