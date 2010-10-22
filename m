Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0JVAGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:06:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab0JVAGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gzQKrC6H1tmv90nhWeEqSuBJBiFkBaHeo/eFdm3px6wlHOf3Tc08E017yZB/GMHDy2
         gazzd0/9kHk+5atYlyEv/VySdY4h9eIaqJNXjKDEEC5vNM4lO9DLCo7SYK5vcR4kCJK3
         Q3Rlsm4Fujov4S8CdYuBjq+6VbJrlCwVj/qLo=
MIME-Version: 1.0
In-Reply-To: <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com>
 <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com>
From: kevin granade <kevin.granade@gmail.com>
Date: Thu, 21 Oct 2010 19:06:23 -0500
Message-ID: <AANLkTimqNW7zArcjtOkBvrn-dk=YE0_RG+u3yoMDTjwV@mail.gmail.com>
Subject: Re: On Linux numbering scheme
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 3:02 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>  Hello,
>
>
>
>  As time passes by, the Linux numbering scheme makes even less sense. Some time ago there was a discussion on LKML about a new numbering scheme but it didn't come to any positive conclusion and then the subject was forgotten entirely. Not meaning to raise a clamour here (and I suppose I represent a large group of Linux users here). I'm willing to suggest a numbering scheme which I hope will answer all known complaints and criticism.

What are the criticisms?  I think outlining the goals might be a good idea:
1. Numbering scheme must monotonically increase with each release when
evaluated as a version number, including transitioning from the
current numbering system.
2. Individual elements of the version number should remain relatively small.

>
>
>
>  The scheme is simple. We start either from 3.0.1 [.stable] or from 3.10.0 [.stable].
>
>
>
>  The first digit will remain "3" forever, to preserve compatibility with all existing utilities and internal Linux kernel code. So, the concern about older utilities breakage is answered here: both 3.0.1 and 3.10.1 are bigger than any currently released kernel.
>
>
>
>  The second number will be either 10 (the current year) or 0 meaning we have reset the numbering altogether. However in my opinion 10 sounds better than 0.
>
>
>
>  Now, more about the second and third numbers. The second number is just the current year in the 21 century or the same number minus 10. The third number will be incremented with every new release until the next year hits. So, the real next year we'll have 3.11.1, 3.11.2, 3.11.3, etc.

Any particular reason not to continue the date-oriented format and
have the third number be the numerical representation of the month
rather than an incrementing numbering of the releases?  It would still
be monotonically increasing, which is the only requirement, right?

>
>
>
>  Now comes a problem, what if we release kernel 3.10.1 this year and the development of the next one commences also this year? What will be the next release number? I suggest to assign the next release number as the following:
>
>
>
>  1) Either regardless the actual year the next kernel gets released (this way the kernel development started in 2010 will yield kernel 3.10.2 even though we hit the next year) or
>
>  2) By the day the kernel gets released, so while in development the kernel version remained 3.10.1-rcX, on the 15th of January, we rename it to 3.11.1.

I very much think the first option is superior, the version number
would mark the opening of the merge window.  With the other option it
introduces a discontinuity into the process that seems unnecessary.

>
>
>  Artem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
