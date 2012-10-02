Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2JBL2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:28:00 -0400
Received: from smtp.getmail.no ([84.208.15.66]:61444 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2JBL17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:27:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Mike Galbraith <efault@gmx.de>
Subject: Re: The 10ms averager in fair.c
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wljhky1q6426ze@millennium.getinternet.no>
 <1349169555.7086.48.camel@marge.simpson.net>
 <op.wljkvfkq6426ze@millennium.getinternet.no>
 <1349176973.7086.96.camel@marge.simpson.net>
Date: Tue, 02 Oct 2012 11:28:27 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wljolpvf6426ze@millennium.getinternet.no>
In-reply-to: <1349176973.7086.96.camel@marge.simpson.net>
User-Agent: Opera Mail/12.02 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2012 13:22:53 +0200, Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2012-10-02 at 10:07 +0200, Uwaysi Bin Kareem wrote:
>> On Tue, 02 Oct 2012 11:19:15 +0200, Mike Galbraith <efault@gmx.de>  
>> wrote:
>>
>> > On Tue, 2012-10-02 at 08:56 +0200, Uwaysi Bin Kareem wrote:
>> >
>> >> What you can do for the time being is just set it to 1nS. If that
>> >> doesn`t
>> >> negatively impact anything, then you know it is bogus.
>> >
>> > I already know that there is negative impact.
>> >
>> > -Mike
>> >
>>
>> You already know? Then please elaborate, what a 10ms smoother is doing  
>> in
>> a nanosecond resolution scheduler.
>
> I already told you.
>
> I passed a piece of information along that I thought would be of use to
> you.  That's all.  I don't like your tone, and owe you nothing, so have
> a nice day, and goodbye.
>
> -Mike
>

Lol. Well, I will just have to fix this on my own then. Imagine if you  
have a nanosecond cpu burst, and calculating load on a 10ms smoothed  
version of that. I really thought that would be easy to understand. I am  
very suprised to find it there, and very surprised at your attitude. If  
you had something actual to say about this, you would have done it in the  
first post. "A lot of groups" means nothing.

Peace Be With You.
