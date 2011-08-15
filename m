Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1HOHiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:38:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34599 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1HOHiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:38:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108150022300.24266@asgard.lang.hm>
References: <20110815041524.GA7578@kroah.com>
	<4E48C136.6090306@web.de>
	<alpine.DEB.2.02.1108150004520.24266@asgard.lang.hm>
	<CAEwRVpMF-eN=9t_V8uFkJ8CAfp8fPd2kHh5a1gonEP5un6qk_A@mail.gmail.com>
	<alpine.DEB.2.02.1108150022300.24266@asgard.lang.hm>
Date: Mon, 15 Aug 2011 15:38:04 +0800
Message-ID: <CAEwRVpNHoO49U11dV9t2mtDDr06xp6RzX9iep4DQOoFB26wMVA@mail.gmail.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: david@lang.hm
Cc: =?ISO-8859-1?Q?J=F6rg=2DVolker_Peetz?= <jvpeetz@web.de>,
        linux-kernel@vger.kernel.org, stable@linux.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 3:25 PM,  <david@lang.hm> wrote:
> On Mon, 15 Aug 2011, Teck Choon Giam wrote:
>
>> 2011/8/15  <david@lang.hm>:
>>>
>>> On Mon, 15 Aug 2011, J?rg-Volker Peetz wrote:
>>>
>>>> Greg KH wrote, on 08/15/11 06:15:
>>>> <snip>
>>>>>
>>>>> - a new -longterm kernel is picked every year.
>>>>> - a -longterm kernel is maintained for 2 years and then dropped.
>>>>
>>>> <snip>
>>>>
>>>> Just a little nitpick: with this scheme you will accumulate longterm
>>>> kernels. If
>>>> I understand it right, one longterm kernel is added every year.
>>>
>>> but with one new kernel being added each year, and then being dropped two
>>> years later, there are only 2 long term kernels at any one time (that
>>> Greg
>>> will be maintaining at least, nothing stops other people from maintaining
>>> other long term kernels in addition)
>>
>> Err... sorry from my understanding like this year... one new long term
>> kernel added so it is N+1 then next year is N+1+1 and two years drop
>> one so it is N+1+1-1... so every year there will be one new long term
>> added and every two years there will be one overall long term kernel
>> added to total number of long term kernels... since two are added
>> within 2 years and one dropped every 2 years.  So there are not only 2
>> long term kernels at any one time in this case... ... someone correct
>> me if I am wrong.
>
> in 2011 there will be a -longterm kernel picked (1 maintained)
>
> in 2012 there will be a -longterm kernel picked (1+1=2 maintained)
>
> in 2013 there will be a -longterm kernel picked, but the 2011 one will no
> longer be maintained (1+1+1-1=2 maintained)
>
> in 2014 there will be a -longterm kernel picked, but the 2012 one will no
> longer be maintained (1+1+1+1-1-1=2 maintained)

Thanks for explaining... :)

Kindest regards,
Giam Teck Choon
