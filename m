Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2J0Kri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 06:47:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46251 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2J0Krg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 06:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121026192517.GC24687@redhat.com>
References: <1351226868-30063-1-git-send-email-robin.k.dong@gmail.com>
	<1351226868-30063-2-git-send-email-robin.k.dong@gmail.com>
	<20121026192517.GC24687@redhat.com>
Date: Sat, 27 Oct 2012 18:47:36 +0800
Message-ID: <CANsebLGyP10Ai9Sta2xqyeTj0xR6dog4uU79a_bQMEb8kXuLrg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] block/throttle: Add IO submitted information in blkio.throttle
From: Robin Dong <robin.k.dong@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/27 Vivek Goyal <vgoyal@redhat.com>:
> On Fri, Oct 26, 2012 at 12:47:48PM +0800, Robin Dong wrote:
>
> [..]
>> @@ -1084,6 +1114,16 @@ static struct cftype throtl_files[] = {
>>               .private = offsetof(struct tg_stats_cpu, serviced),
>>               .read_seq_string = tg_print_cpu_rwstat,
>>       },
>> +     {
>> +             .name = "throttle.io_submit_bytes",
>
> Do we really need io_submit_bytes stats? Your need seems to be able to
> figure out if there are pending IOs in the group and if you need to
> increase the bandwidth. For that, isn't number of bios enough?

 I just want to be more consistent to "io_service_bytes" and "io_serviced" pair

>
> Also even if we retain bytes, let us change it to "io_submitted_bytes".

Since "io_service_bytes" is "service", I use "io_submit_bytes"....
Never mind, "io_submitted_bytes" is much better.

>
> Thanks
> Vivek



-- 
--
Best Regard
Robin Dong
