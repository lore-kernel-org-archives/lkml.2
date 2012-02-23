Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2BWHZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:25:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65304 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2BWHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:24:59 -0500
X-AuditID: 9c930197-b7cdbae000001518-d3-4f45e9c8316a
Message-ID: <4F45E9C5.4020900@lge.com>
Date: Thu, 23 Feb 2012 16:24:53 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Yuanfang Chen <cyfmxc@gmail.com>
CC: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com> <4F4484AC.9050500@lge.com> <87ehtnhz9w.fsf@gmail.com> <CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com>
In-Reply-To: <CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-23 4:03 AM, Yuanfang Chen wrote:
> On Wed, Feb 22, 2012 at 6:40 AM, Namhyung Kim <namhyung@gmail.com> wrote:
>> Namhyung Kim <namhyung.kim@lge.com> wrote:
>>> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>>>> I'm trying use perf tool from the linux kernel package to measure
>>>> several raw PMU events. In the manpage of perf-record there is an "-l"
>>>> option (Scale counter values), which is useful for my case because I
>>>> want to know the total counter value, not just sample count. However
>>>> it seems the -l is not recognized, is this expected? How can I get a
>>>> total count?
>>>
>>> "perf report --show-total-period" will be your friend.
>>
>> Or else, why not simply run "perf stat"?
>
> My purpose is to get some PMU counter value during each time interval,
> only perf record can do this. When using perf record -F, I have to add
> up all period value for some event in a some interval to get that
> value. When perf record -c, things get a easier, just (sample count x
> sample after value) will do, only hassle is to get sample count in
> some time interval. However, perf record don't have an option to do
> this.
>

I still don't get it. Why "perf stat -e <events> -p <pid> -- sleep <interval>"
doesn't work for you? It will show you the value, won't it?

Thanks,
Namhyung
