Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2BVTDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:03:31 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33695 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2BVTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:03:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.229.114.210 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
X-Google-Sender-Delegation: tabloid.adroit@gmail.com
In-Reply-To: <87ehtnhz9w.fsf@gmail.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
	<87ehtnhz9w.fsf@gmail.com>
Date: Wed, 22 Feb 2012 14:03:27 -0500
X-Google-Sender-Auth: i81UhiMj03s99zo9QXqpx8nr_hg
Message-ID: <CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com>
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 6:40 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Namhyung Kim <namhyung.kim@lge.com> wrote:
>>
>> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>>> Hi all,
>>>
>>
>> Hi,
>>
>>
>>> I'm trying use perf tool from the linux kernel package to measure
>>> several raw PMU events. In the manpage of perf-record there is an "-l"
>>> option (Scale counter values), which is useful for my case because I
>>> want to know the total counter value, not just sample count. However
>>> it seems the -l is not recognized, is this expected? How can I get a
>>> total count?
>>>
>>
>> "perf report --show-total-period" will be your friend.
>>
>
> Or else, why not simply run "perf stat"?

My purpose is to get some PMU counter value during each time interval,
only perf record can do this. When using perf record -F, I have to add
up all period value for some event in a some interval to get that
value. When perf record -c, things get a easier, just (sample count x
sample after value) will do, only hassle is to get sample count in
some time interval. However, perf record don't have an option to do
this.

>
> Thanks,
> Namhyung
