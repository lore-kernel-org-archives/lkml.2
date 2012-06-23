Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2FWW6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 18:58:13 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48442 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754547Ab2FWW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 18:58:12 -0400
Message-ID: <4FE649E8.5090103@xenotime.net>
Date: Sat, 23 Jun 2012 15:57:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>	<20120623161324.GS11413@one.firstfloor.org>	<24bd04a1-1702-4d57-af64-af2381992789@email.android.com> <CAMe9rOrH6_0mDzCnfTtydEVCn11A9wqn7MD0xHz9dOhPw1WZ1w@mail.gmail.com>
In-Reply-To: <CAMe9rOrH6_0mDzCnfTtydEVCn11A9wqn7MD0xHz9dOhPw1WZ1w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 09:49 AM, H.J. Lu wrote:

> On Sat, Jun 23, 2012 at 9:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> To keep gcc from paddong the stack to maintain a nonexistent alignment.
>>
>> Andi Kleen <andi@firstfloor.org> wrote:
>>
>>>> This patch uses -mpreferred-stack-boundary=3 on x86-64 if it is
>>> supported.
>>>> I have been running 3.4 kernel compiled with this option for weeks.
>>>
>>> But why?
>>>
>>> All the SSE code in the kernel should adjust manually. And the other
>>> code doesn't need it.
>>>
>>> Besides the entry points do not guarantee alignment.
>>>
>>> For the kernel it would be probably more useful to have a attribute
>>> per function that forces alignment.
> 
> There was an attempt from you to do it in 2007:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0708.2/2604.html
> http://gcc.gnu.org/ml/gcc-patches/2007-07/msg01697.html
> 
> But the gcc patch was never checked in.
> 
> 


Some (most) of this explanation needs to be in the patch description.


-- 
~Randy
