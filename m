Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0LYN4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 08:56:47 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33604 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0LYN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 08:56:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FMRlljhp3+qNJXS3usRvBPeKiK8xqLtUEAXK+F1138fFEy8zlJs9q1xRrhdkyI1a3b
         t0cReUyBJrgXRt0Jt0CT49aWQlUu+FvzFm1yPpGGK1hluh/qkp+TpaRdTU4ezEhtAhQB
         muaAChe4NyVuT9UTO5+juDkjNBjOTdkJPusL8=
MIME-Version: 1.0
In-Reply-To: <20101224171459.GA31815@suse.de>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
	<20101224035523.GC25057@suse.de>
	<AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
	<20101224171459.GA31815@suse.de>
Date: Sat, 25 Dec 2010 21:56:44 +0800
Message-ID: <AANLkTimvjGvoSs2T0BmdaMdKyAsnttSXXRiJp0wB4+bG@mail.gmail.com>
Subject: Re: [PATCH] fix freeing user_struct in user cache
From: Hillf Danton <dhillf@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 1:14 AM, Greg KH <gregkh@suse.de> wrote:
> That was a stable patch, I send all of those out :)
>
> Use scripts/get_maintainer.pl to determine the best person to send this
> patch to (hint, it's not me.)

thanks, Greg, for sending it out, and merry Christmas.

Hillf

>
> thanks,
>
> greg k-h
>
