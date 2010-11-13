Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0KMTFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:05:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35886 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab0KMTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Enw3ISi8IyQ8SIAG7mgNAVGYrnzU/uxc5+n4G+0zMUKfWO9gD0XMfv/t1Wh1TTKWzr
         TBQfrTBka0nS4dDy03Zx38Lav1vQRkcJ+RIaPDflpTByj3q7IpCYRwfYSfLTKaIfgXfq
         i5TTFId1pccuBGJB9LH+3Gx6tq5amOih+GPJE=
MIME-Version: 1.0
In-Reply-To: <20101111002651.GA21632@kroah.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
	<1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
	<20101111002651.GA21632@kroah.com>
Date: Sat, 13 Nov 2010 20:05:40 +0100
Message-ID: <AANLkTimteY1P_gU5+ArA8xg3FzS0m9kdQygXSptvhGuh@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging: ft1000: Remove unused char dev inerface.
From: Belisko Marek <marek.belisko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Nov 11, 2010 at 1:26 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 10, 2010 at 11:15:27AM +0100, Marek Belisko wrote:
>> This patch remove lot of code for character device. This
>> interface was used for getting network informations and
>> statistics which is currently exported via /proc filesystem.
>>
>> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
>
> This patch does not apply :(
I'm trying to resend but need to wait till linux-next will sync with
linus kernel.
In mainline there is a patch (61241d97db02559bd83d21ffa783ab327945b925) which
is not in linux-next.

I try to apply patch for mainline but it failed. I'll fix and resend then.
Hopefully this is correct if not forgive me ;)
>
> thanks,
>
> greg k-h
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
