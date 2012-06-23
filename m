Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2FWQtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:49:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47920 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2FWQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <24bd04a1-1702-4d57-af64-af2381992789@email.android.com>
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
	<20120623161324.GS11413@one.firstfloor.org>
	<24bd04a1-1702-4d57-af64-af2381992789@email.android.com>
Date: Sat, 23 Jun 2012 09:49:22 -0700
Message-ID: <CAMe9rOrH6_0mDzCnfTtydEVCn11A9wqn7MD0xHz9dOhPw1WZ1w@mail.gmail.com>
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 9:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> To keep gcc from paddong the stack to maintain a nonexistent alignment.
>
> Andi Kleen <andi@firstfloor.org> wrote:
>
>>> This patch uses -mpreferred-stack-boundary=3 on x86-64 if it is
>>supported.
>>> I have been running 3.4 kernel compiled with this option for weeks.
>>
>>But why?
>>
>>All the SSE code in the kernel should adjust manually. And the other
>>code doesn't need it.
>>
>>Besides the entry points do not guarantee alignment.
>>
>>For the kernel it would be probably more useful to have a attribute
>>per function that forces alignment.

There was an attempt from you to do it in 2007:

http://lkml.indiana.edu/hypermail/linux/kernel/0708.2/2604.html
http://gcc.gnu.org/ml/gcc-patches/2007-07/msg01697.html

But the gcc patch was never checked in.


-- 
H.J.
