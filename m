Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1HQLH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:07:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42819 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1HQLH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAEwRVpMF-eN=9t_V8uFkJ8CAfp8fPd2kHh5a1gonEP5un6qk_A@mail.gmail.com>
References: <20110815041524.GA7578@kroah.com>
	<4E48C136.6090306@web.de>
	<alpine.DEB.2.02.1108150004520.24266@asgard.lang.hm>
	<CAEwRVpMF-eN=9t_V8uFkJ8CAfp8fPd2kHh5a1gonEP5un6qk_A@mail.gmail.com>
Date: Wed, 17 Aug 2011 12:07:26 +0100
Message-ID: <CAAMvbhFEYYENwer30kBJU=yhM2LFaOhMYGQZjUBhbMOZeWS5uQ@mail.gmail.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: david@lang.hm, =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>,
        linux-kernel@vger.kernel.org, stable@linux.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2011 08:16, Teck Choon Giam <giamteckchoon@gmail.com> wrote:
> 2011/8/15  <david@lang.hm>:
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
> within 2 years and one dropped every 2 years.  So there are not only 2
> long term kernels at any one time in this case... ... someone correct
> me if I am wrong.
>

I think your maths might be wrong.

Year 1, long term kernel 1 starts  (total concurrent long term = 1)
Year 2, long term kernel 2 starts  (total concurrent long term = 2)
Year 3, long term kernel 3 starts, long term kernel 1 stops. (total
concurrent long term = 2)
Year 4, long term kernel 4 starts, long term kernel 2 stops. (total
concurrent long term = 2)
Year 5, long term kernel 5 starts, long term kernel 3 stops. (total
concurrent long term = 2)
