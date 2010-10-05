Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0JEVvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:51:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63515 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0JEVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p9VmhdMN3vFC0skn3xlMg3cAjgcNQ5m9QKmxAEObv+KyRnjZsAVrfgHocOyr5Nwt8L
         oPk9WlcK0w6uicTHOlEaLrOeVrJ+EQhsY0Kt9wl9eS+0lKoYkxIA5LiS89Ji2DGjNBcu
         YSPv5qSex4DUIvKNY9+Oo1fxztAkkE0ci92dE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimY3iVfQgpNqJAVATFCMaQ1b=xyvyVKctyxMkFs@mail.gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
	<1286037489-28439-12-git-send-email-tdent48227@gmail.com>
	<20101005190209.GA3386@kroah.com>
	<AANLkTimY3iVfQgpNqJAVATFCMaQ1b=xyvyVKctyxMkFs@mail.gmail.com>
Date: Tue, 5 Oct 2010 17:51:10 -0400
Message-ID: <AANLkTikQAjc6+SsheaxjFZr8vNDxdGjb7sDxX+oMStko@mail.gmail.com>
Subject: Re: [PATCH v3 12/20] Staging: rtl8192su: ieee80211: Makefile: cleaned
 up Makefile cflag lines
From: T Dent <tdent48227@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/10, T Dent <tdent48227@gmail.com> wrote:
> On 10/5/10, Greg KH <greg@kroah.com> wrote:
>> On Sat, Oct 02, 2010 at 12:38:01PM -0400, Tracey Dent wrote:
>>> Changed to use the proper ccflags-y option
>>>
>>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>>> ---
>>>  drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
>>
>> This file is no longer in linux-next.
>
> I Didn't know that. I guess because I did the patches based on the
> current linus tree.
> So you want me to resend it without this driver?

Never mind, I just seen the message you sent me. Got a lot of messages
and must have skip over it , Sorry.
>>
>> thanks,
>>
>> greg k-h
>>
>
> Thanks,
>
> Tracey D
>

Thanks,

Tracey D
