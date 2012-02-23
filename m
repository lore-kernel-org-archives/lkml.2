Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2BWS5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:57:14 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33616 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2BWS5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:57:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.229.78.159 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F45ED78.2010007@lge.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
	<CAJh9x3psvYArTQOBQa-TVBsW16qRTPJp+0L8hYJQTK7EJYy1tQ@mail.gmail.com>
	<4F45ED78.2010007@lge.com>
Date: Thu, 23 Feb 2012 13:57:10 -0500
Message-ID: <CAJh9x3pE9HJTQb4aZjZ=YXgm7um3D7MX7hJ8pPq6kekAZHTTEA@mail.gmail.com>
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:40 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> 2012-02-23 3:57 AM, Yuanfang Chen wrote:
>>
>> On Wed, Feb 22, 2012 at 1:01 AM, Namhyung Kim <namhyung.kim@lge.com>
>> wrote:
>>>
>>> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>>> The "-l" option was meaningful only if you specified events more than the
>>> actual number of counters in the PMU.
>>
>>
>> So -l is for multiplexing?
>>
>
> The "-l" option is no longer supported in perf record/report and
> multiplexing is always enabled by default, if needed. That would be the same
> even for old versions AFAIK, and "-l" option just controlled whether it'd
> scale or not the counter value which is taken from already multiplexed
> events.
>

My question may sounds silly, but why to scale the counter value? Why
it is deprecated now?

Thank you,
yuanfang

>
> Thanks,
> Namhyung
