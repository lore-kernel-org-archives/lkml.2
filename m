Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab2EKPgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:36:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58011 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866Ab2EKPgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120511151944.GA6990@kroah.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 08:35:47 -0700
X-Google-Sender-Auth: XrFPStiXaPL9mHvSvNksWEFGHZw
Message-ID: <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Yinghai Lu <yinghai@kernel.org>, Joe Perches <joe@perches.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 8:19 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> What code does this?  Shouldn't those be individual printk lines?  I
> didn't think that type of line would ever work properly in the past.

We've *always* supported multiple lines, Greg. And it has always
worked. It's very inconvenient to have to use multiple printk's when
one would do.

That said, I think it would be interesting if the timing values were
just not printed at all when they match the last one, which would
happen with this kind of setup (and also happens if your time source
sucks).

You'd still want the lines to line up, though.

                       Linus
