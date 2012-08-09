Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2HIM47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:56:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38540 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HIM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <87zk64yk63.fsf@sejong.aot.lge.com>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
	<87mx26z0it.fsf@sejong.aot.lge.com>
	<CANaxB-xAWtj8nU0WiE0aV_WHde_iX=rseU9NwwN=VTHOZYW=JQ@mail.gmail.com>
	<878vdqympe.fsf@sejong.aot.lge.com>
	<CANaxB-zZp0How3+WUC2BMsRMWBgf1CVkaVQSYWcvCXTgyymSvg@mail.gmail.com>
	<87zk64yk63.fsf@sejong.aot.lge.com>
Date: Thu, 9 Aug 2012 16:56:56 +0400
Message-ID: <CANaxB-zWt97Vq7nfeDXeU-A84jUki+cuOLhrv2aRfah6QBuTFg@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Teach perf tool to profile sleep times (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/9 Namhyung Kim <namhyung@kernel.org>:
>>>>> The usage like this is too specific and hard to use IMHO. How about
>>>>> putting it somehow into perf sched or new command?
>>>>>
>>>>> /me don't have an idea though. :-)
>>>>>
>>>>
>>>> I'm going to add a script, so the usage will look like this:
>>>> $ perf script record sched-stat -e sched:sched_stat_sleep <command>
>>>> This command will collect sched_stat_* and proper sched_switch events
>>>
>>> ???  That means '-e sched:sched_stat_sleep' part can be removed from
>>> command line, no?
>>
>> No. My method works for all kind of sched_stat_* events, so you need
>> to specify an event type which should be traced.
>
> Ok, so can it be like 'perf script record sched-stat -t sleep <command>'?

Yes, it can. Thanks for your feedback. I'm going to write the script,
when this series will be committed.
