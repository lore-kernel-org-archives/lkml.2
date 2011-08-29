Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1H2PLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:11:13 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:38647 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1H2PLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108291637470.3904@dhcp-27-109.brq.redhat.com>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
	<alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
	<CAF1ivSY0NwdZTCQQ_BG5Vk8rnjiH=sS0V08ajxc8Gw5YBwD3qA@mail.gmail.com>
	<alpine.LFD.2.00.1108291637470.3904@dhcp-27-109.brq.redhat.com>
Date: Mon, 29 Aug 2011 23:11:03 +0800
Message-ID: <CAF1ivSYu=0Xh3aXJGbuBUZjT_azLTO6Tq1gzhNRBWsHXCUMjiw@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
From: Lin Ming <lxy@ss.pku.edu.cn>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Mon, 29 Aug 2011, Lin Ming wrote:
>
>> On Mon, Aug 29, 2011 at 7:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> >
>> > Regarding the atomic operations I do not think that implicit memory
>> > barriers are needed here as atomic_dec_and_test() implies memory
>>
>> Which implicit memory barrier you are talking about?
>
> smp_mb() at both side of the operation as documented here in
> Documentation/memory-barriers.txt

Thanks for the info.

But I don't follow you ... why that implicit memory barriers are NOT needed?
