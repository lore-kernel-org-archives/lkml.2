Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0JEVrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:47:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38579 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0JEVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fj5OKXopYuwVU5kwZvxkAcCchMJw+ZChLOTbZpcYjZYX1Emq0lrH1i9DdTkueE487s
         GLWSOdM6dadbqNgTsRc6+dWK5IxrAzEegtDjHc2Z+qd9FmEEhtJgphfDGW66lsvKw0KH
         uouDx2i+b6mrlnygyrZ04uVXsyS0iJ/oYJLjA=
MIME-Version: 1.0
In-Reply-To: <20101005190209.GA3386@kroah.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
	<1286037489-28439-12-git-send-email-tdent48227@gmail.com>
	<20101005190209.GA3386@kroah.com>
Date: Tue, 5 Oct 2010 17:47:23 -0400
Message-ID: <AANLkTimY3iVfQgpNqJAVATFCMaQ1b=xyvyVKctyxMkFs@mail.gmail.com>
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

On 10/5/10, Greg KH <greg@kroah.com> wrote:
> On Sat, Oct 02, 2010 at 12:38:01PM -0400, Tracey Dent wrote:
>> Changed to use the proper ccflags-y option
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>> ---
>>  drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
>
> This file is no longer in linux-next.

I Didn't know that. I guess because I did the patches based on the
current linus tree.
So you want me to resend it without this driver?
>
> thanks,
>
> greg k-h
>

Thanks,

Tracey D
