Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2B0PFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:05:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59017 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2B0PFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:05:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.224.181.130 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAJh9x3o3M+PWW8k6Ns51pQaMjEtWDmD3s8P0P_6_jro5zh66bA@mail.gmail.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
	<87ehtnhz9w.fsf@gmail.com>
	<CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com>
	<4F45E9C5.4020900@lge.com>
	<CAJh9x3o7HLGBWrwBaGgxXS-C9noQbKwh5BP_PAHomOOS6x9SYw@mail.gmail.com>
	<CAJh9x3o4ELjmrmYhba_R-8G6TciuXY9M3PpjAeCtFNaPmvpKHA@mail.gmail.com>
	<4F468EBB.9000209@gmail.com>
	<CAJh9x3rxK42wFXqCASex1YwMKofWdZ=g-OnH43BHDtUjeMabbA@mail.gmail.com>
	<4F4AF727.2040105@gmail.com>
	<CAJh9x3oO+-8Bc4UONG6RTmSeVFcuNHTKH5m2KsizaubmSojYmw@mail.gmail.com>
	<CAJh9x3qoF=WdmfaTUTGjKWzPbw7TNb3cG+=mi=YFVQ9q76o6yQ@mail.gmail.com>
	<4F4B963F.4060705@gmail.com>
	<CAJh9x3o3M+PWW8k6Ns51pQaMjEtWDmD3s8P0P_6_jro5zh66bA@mail.gmail.com>
Date: Mon, 27 Feb 2012 10:05:47 -0500
Message-ID: <CAJh9x3otaAhOz0n-nVjuA-iZzvy6ZExN-JFQ_EhYpDn6YJzKDw@mail.gmail.com>
Subject: Fwd: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Yuanfang Chen <cyfmxc@gmail.com>
Date: Mon, Feb 27, 2012 at 10:05 AM
Subject: Re: perf record: can I specify multiple events and use
different sample-after value
To: David Ahern <dsahern@gmail.com>


On Mon, Feb 27, 2012 at 9:42 AM, David Ahern <dsahern@gmail.com> wrote:
> On 2/27/12 6:58 AM, Yuanfang Chen wrote:
>>
>> On Mon, Feb 27, 2012 at 8:56 AM, Yuanfang Chen<cyfmxc@gmail.com>  wrote:
>>>
>>>
>>> On Feb 26, 2012 10:23 PM, "David Ahern"<dsahern@gmail.com>  wrote:
>>>>
>>>>
>>>> On 2/24/12 3:41 PM, Yuanfang Chen wrote:
>>>>>
>>>>>
>>>>> I think I'll settle with perf record for now. Still, unlike trace
>>>>> event, sample count is not meaningful for PMU event. Output of "perf
>>>>> script" does not include period value. One line of code will do the
>>>>> work.
>>>>>
>>>>> lude 17342 750118.202915: raw 0x3c: 86754      ffffffff8115f6b9
>>>>> __mem_cgroup_commit_char
>>>>> lude 17342 750118.203025: raw 0x3c: 1027634   ffffffff811344b9
>>>>> __mem_cgroup_commit_char
>>>>>
>>>>> 86754, 1027634 is the period value. But I'm not sure which is the PMU
>>>>> value, is it just period value, or period x sample after. If so, what
>>>>> is the sample after value?
>>>>
>>>>
>>>>
>>>> You lost me. You modified perf-script to print the period?
>>>>
>>>> Are you asking for the PMU counter value for 0x3c?
>>
>>
>>      yes
>
>
> perf-record does not get counter values when samples are genereated.

  If so, it make sense to sample trace event. But what's the point to
sample an PMU event?
  If using perf-record -c , counter values is available indirectly.

>
>>
>>>>
>>>> What perf commands are you running?
>>
>>
>>     perf script
>>     (with no options)
>
>
> record command?
>
> I don't see what the 86754 and 1902764 values are in your example output
> above.

It's the period value in that sample. However, I'm not sure what
period mean here.

>
>
> David
