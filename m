Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2EMWTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 18:19:30 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:11607 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2EMWT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 18:19:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAYYNrheKGIEvjhOBGASpJYFA
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="180027119"
Message-ID: <4FB0336F.9050600@teksavvy.com>
Date: Sun, 13 May 2012 18:19:27 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sasha Levin <levinsasha928@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com> <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com> <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com> <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop> <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com> <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com> <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com> <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com> <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com> <4FAFB57C.40906@teksavvy.com> <CA+55aFwrc2rbDyJgChwkfWBrZtmoVdC-abH0eOvs_zpnq1MPDQ@mail.gmail.com>
In-Reply-To: <CA+55aFwrc2rbDyJgChwkfWBrZtmoVdC-abH0eOvs_zpnq1MPDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-13 02:01 PM, Linus Torvalds wrote:
> On Sun, May 13, 2012 at 6:22 AM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> Look in syslog ?
> 
> That usually requires root permission, so it's an extra (annoying)
> step. It also gives all kinds or other mostly irrelevant information
> for a kernel person.
> 
> Besides, according to the same argument, dmesg shouldn't have times
> *at*all*. So the "look in your syslog" is pointless for discussing the
> dmesg timestamp.

It's good for dates.  Not as good for times.
I figure anyone trying to diagnose a kernel issue
already has access to /var/log/ as well.  :)

But it's good as you propose with an option.

Cheers
