Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2EMSBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:01:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64925 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2EMSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <4FAFB57C.40906@teksavvy.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
 <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com>
 <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com>
 <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com>
 <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com>
 <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com> <4FAFB57C.40906@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 May 2012 11:01:31 -0700
X-Google-Sender-Auth: Rd41rgrXga14tanVOCBKyHWApj8
Message-ID: <CA+55aFwrc2rbDyJgChwkfWBrZtmoVdC-abH0eOvs_zpnq1MPDQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Mark Lord <kernel@teksavvy.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 6:22 AM, Mark Lord <kernel@teksavvy.com> wrote:
>
> Look in syslog ?

That usually requires root permission, so it's an extra (annoying)
step. It also gives all kinds or other mostly irrelevant information
for a kernel person.

Besides, according to the same argument, dmesg shouldn't have times
*at*all*. So the "look in your syslog" is pointless for discussing the
dmesg timestamp.

                   Linus
