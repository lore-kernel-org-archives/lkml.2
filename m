Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2ELSE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 14:04:27 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:42068 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2ELSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 14:04:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAbQkihiBL44TgRgEqSU
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="179828121"
Message-ID: <4FAEA628.5000604@teksavvy.com>
Date: Sat, 12 May 2012 14:04:24 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kay Sievers <kay@vrfy.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com> <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com> <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com> <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com> <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop> <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com> <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com> <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com> <4FAD6DCA.4030909@teksavvy.com> <CA+55aFw6=WZaw7iOwozpsOLhWP6yJSJM+TY0Z8ySStRE6PR+fA@mail.gmail.com>
In-Reply-To: <CA+55aFw6=WZaw7iOwozpsOLhWP6yJSJM+TY0Z8ySStRE6PR+fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-11 04:02 PM, Linus Torvalds wrote:
> On Fri, May 11, 2012 at 12:51 PM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> Breaks the "grep for specific messages" case.
> 
> Why?
> 
> Sure, if you grep for times, you'd not want to enable the relative
> time. But why would you grep for a time anyway? Regardless, it would
> be your choice.


I'd be grepping for specific message content, not times.
But I'd want to see the times for the messages,
to know if they're related events or not.

Relative times are great, no problem there.
But relative to what?  The previous message?

That's no good unless viewing all messages,
rather than a grep'd subset.

But with a choice, we do get the best of both, so no problemo.

Cheers
