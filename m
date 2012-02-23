Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2BWSwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:52:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33769 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2BWSwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:52:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.229.114.210 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAJh9x3o7HLGBWrwBaGgxXS-C9noQbKwh5BP_PAHomOOS6x9SYw@mail.gmail.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
	<87ehtnhz9w.fsf@gmail.com>
	<CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com>
	<4F45E9C5.4020900@lge.com>
	<CAJh9x3o7HLGBWrwBaGgxXS-C9noQbKwh5BP_PAHomOOS6x9SYw@mail.gmail.com>
Date: Thu, 23 Feb 2012 13:52:09 -0500
Message-ID: <CAJh9x3o4ELjmrmYhba_R-8G6TciuXY9M3PpjAeCtFNaPmvpKHA@mail.gmail.com>
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 1:51 PM, Yuanfang Chen <cyfmxc@gmail.com> wrote:
> On Thu, Feb 23, 2012 at 2:24 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
>> 2012-02-23 4:03 AM, Yuanfang Chen wrote:
>>>
>>> On Wed, Feb 22, 2012 at 6:40 AM, Namhyung Kim <namhyung@gmail.com> wrote:
>>>>
>>>> Namhyung Kim <namhyung.kim@lge.com> wrote:
>>>>>
>>>>> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>>>>>>
>>>>>> I'm trying use perf tool from the linux kernel package to measure
>>>>>> several raw PMU events. In the manpage of perf-record there is an "-l"
>>>>>> option (Scale counter values), which is useful for my case because I
>>>>>> want to know the total counter value, not just sample count. However
>>>>>> it seems the -l is not recognized, is this expected? How can I get a
>>>>>> total count?
>>>>>
>>>>>
>>>>> "perf report --show-total-period" will be your friend.
>>>>
>>>>
>>>> Or else, why not simply run "perf stat"?
>>>
>>>
>>> My purpose is to get some PMU counter value during each time interval,
>>> only perf record can do this. When using perf record -F, I have to add
>>> up all period value for some event in a some interval to get that
>>> value. When perf record -c, things get a easier, just (sample count x
>>> sample after value) will do, only hassle is to get sample count in
>>> some time interval. However, perf record don't have an option to do
>>> this.
>>>
>>
>> I still don't get it. Why "perf stat -e <events> -p <pid> -- sleep
>> <interval>"
>> doesn't work for you? It will show you the value, won't it?
>
> say my application(not an existing process, so -p <pid> does not
> work.) run for 10 seconds. I want the r03c, r2d4 value during each
> second.  So there will be two values for each event in one second.

oops, forgot to forward. :-)

>
>>
>> Thanks,
>> Namhyung
