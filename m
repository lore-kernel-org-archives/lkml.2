Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2BVLkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 06:40:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44165 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2BVLkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 06:40:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of namhyung@gmail.com designates 10.68.219.136 as permitted sender) smtp.mail=namhyung@gmail.com; dkim=pass header.i=namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Yuanfang Chen <cyfmxc@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: perf record: can I specify multiple events and use different sample-after value
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
Date: Wed, 22 Feb 2012 20:40:27 +0900
In-Reply-To: <4F4484AC.9050500@lge.com> (Namhyung Kim's message of "Wed, 22
	Feb 2012 15:01:16 +0900")
Message-ID: <87ehtnhz9w.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung.kim@lge.com> wrote:
>
> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>> Hi all,
>>
>
> Hi,
>
>
>> I'm trying use perf tool from the linux kernel package to measure
>> several raw PMU events. In the manpage of perf-record there is an "-l"
>> option (Scale counter values), which is useful for my case because I
>> want to know the total counter value, not just sample count. However
>> it seems the -l is not recognized, is this expected? How can I get a
>> total count?
>>
>
> "perf report --show-total-period" will be your friend.
>

Or else, why not simply run "perf stat"?

Thanks,
Namhyung
