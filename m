Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1HOHZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:25:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:44251 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1HOHZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:25:38 -0400
Date: Mon, 15 Aug 2011 00:25:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Teck Choon Giam <giamteckchoon@gmail.com>
cc: =?ISO-8859-15?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>,
        linux-kernel@vger.kernel.org, stable@linux.kernel.org
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick
 them).
In-Reply-To: <CAEwRVpMF-eN=9t_V8uFkJ8CAfp8fPd2kHh5a1gonEP5un6qk_A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1108150022300.24266@asgard.lang.hm>
References: <20110815041524.GA7578@kroah.com> <4E48C136.6090306@web.de> <alpine.DEB.2.02.1108150004520.24266@asgard.lang.hm> <CAEwRVpMF-eN=9t_V8uFkJ8CAfp8fPd2kHh5a1gonEP5un6qk_A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Teck Choon Giam wrote:

> 2011/8/15  <david@lang.hm>:
>> On Mon, 15 Aug 2011, J?rg-Volker Peetz wrote:
>>
>>> Greg KH wrote, on 08/15/11 06:15:
>>> <snip>
>>>>
>>>> - a new -longterm kernel is picked every year.
>>>> - a -longterm kernel is maintained for 2 years and then dropped.
>>>
>>> <snip>
>>>
>>> Just a little nitpick: with this scheme you will accumulate longterm
>>> kernels. If
>>> I understand it right, one longterm kernel is added every year.
>>
>> but with one new kernel being added each year, and then being dropped two
>> years later, there are only 2 long term kernels at any one time (that Greg
>> will be maintaining at least, nothing stops other people from maintaining
>> other long term kernels in addition)
>
> Err... sorry from my understanding like this year... one new long term
> kernel added so it is N+1 then next year is N+1+1 and two years drop
> one so it is N+1+1-1... so every year there will be one new long term
> added and every two years there will be one overall long term kernel
> added to total number of long term kernels... since two are added
> within 2 years and one dropped every 2 years.  So there are not only 2
> long term kernels at any one time in this case... ... someone correct
> me if I am wrong.

in 2011 there will be a -longterm kernel picked (1 maintained)

in 2012 there will be a -longterm kernel picked (1+1=2 maintained)

in 2013 there will be a -longterm kernel picked, but the 2011 one will no 
longer be maintained (1+1+1-1=2 maintained)

in 2014 there will be a -longterm kernel picked, but the 2012 one will no 
longer be maintained (1+1+1+1-1-1=2 maintained)

David Lang
