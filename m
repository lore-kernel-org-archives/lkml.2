Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1EGRUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:20:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58657 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1EGRUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=czvalPlM2zb4EzNi/ZSYlmaabhQkFRq26R85CssmdxCm3DJ8V2dVXc3fV5yxiFrim8
         MapRAItVmgJkJvbxpWsxuQ3TZCTWABHpOwl2pmzvYUSXVsYnVQ+t8A6aQXWRBVyufhWB
         ostvQikHUf7234aKkRECl81bo5HXUaTIT9ATg=
MIME-Version: 1.0
In-Reply-To: <201105020056.05124.rjw@sisk.pl>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
	<G9uL1cldhmL.A.O0E.HWGvNB@chimera>
	<BANLkTi=jZnpzz2TA4d-370msGhg=M7iHzQ@mail.gmail.com>
	<201105020056.05124.rjw@sisk.pl>
Date: Sun, 8 May 2011 01:20:04 +0800
Message-ID: <BANLkTik+MP-9Ez20KvArV-MRZRPai+fPJQ@mail.gmail.com>
Subject: Re: [Bug #33272] drm related hard-hang
From: Peter Teoh <htmldeveloper@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did an update (2.6.39-rc6+) today and the system seemed very stable,
all previously reported bugs i have has all disappeared.   i tested it
with Chrome browser usage heavily, and kernel tracing with systemtap
and all seemed very stable.   Thanks.


2011/5/2 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday, May 01, 2011, Peter Teoh wrote:
>> sorry, i did a git-update to 2.6.39-rc4 and it failed for me (hard hanged
>> too) in other ways:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=34182
>>
>> so i have not been able to test this, but definitely 2.6.39-rc3 is not
>> working as far as Intel DRM is concerned.
>
> Thanks for the update.
>
> Rafael
>



-- 
Regards,
Peter Teoh
