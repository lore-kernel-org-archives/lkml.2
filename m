Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2BVGBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:01:30 -0500
Received: from plane.gmane.org ([80.91.229.3]:49445 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab2BVGB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:01:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
Date: Wed, 22 Feb 2012 15:01:16 +0900
Message-ID: <4F4484AC.9050500@lge.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
In-Reply-To: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-22 10:59 AM, Yuanfang Chen wrote:
> Hi all,
>

Hi,


> I'm trying use perf tool from the linux kernel package to measure
> several raw PMU events. In the manpage of perf-record there is an "-l"
> option (Scale counter values), which is useful for my case because I
> want to know the total counter value, not just sample count. However
> it seems the -l is not recognized, is this expected? How can I get a
> total count?
>

"perf report --show-total-period" will be your friend.

BTW, it seems you were using old version of perf (and kernel too, maybe).
I have no idea if your perf wouldn't support the option. :)

The "-l" option was meaningful only if you specified events more than the 
actual number of counters in the PMU.


> Another question is that how can I specify multiple events and use
> different sample-after value for each of them? like perf record -c
> 10000,2000000,2000000 -e r2d4,r03c,r0c0
>

It's not possible now. You should run a number of instances of perf for
that purpose AFAIK.


Thanks,
Namhyung

