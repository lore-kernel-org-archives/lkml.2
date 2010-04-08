Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0DHQmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:42:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab0DHQmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:42:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bhrRIQIUMERlbjPhCbKshT52dtDk5HIynLmcyx7pFAA/P/EDv+CZ99o2ho6hQSCRQ
	3gvqa80BH40CBsItJ1XkA==
MIME-Version: 1.0
In-Reply-To: <20100408124629.GN10103@kernel.dk>
References: <20100406232533.25602.46349.stgit@austin.mtv.corp.google.com> 
	<4BBD3DB9.8090006@cn.fujitsu.com> <20100408124629.GN10103@kernel.dk>
From: Divyesh Shah <dpshah@google.com>
Date: Thu, 8 Apr 2010 09:41:44 -0700
Message-ID: <m2taf41c7c41004080941xb29833b0k42c9dab8901f16ca@mail.gmail.com>
Subject: Re: [PATCH][v3.1] blkio: Add io controller stats like
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 5:46 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Apr 08 2010, Gui Jianfeng wrote:
>> Divyesh Shah wrote:
>> > - io_service_time (the total time between request dispatch and completion for
>> >   all IOs in the cgroup)
>> > - io_wait_time (the total time spent waiting by all IOs in this cgroup in the IO
>> >   scheduler queues before getting serviced)
>> > - io_serviced (number of IOs serviced from this blkio_group)
>> > - io_service_bytes (Number of bytes served for this cgroup)
>> >
>> > These stats are accumulated per operation type helping us to distinguish between
>> > read and write, and sync and async IO. This patch does not increment any of
>> > these stats.
>> >
>> > Changelog from v3:
>> > o renamed blkiocg_reset_write to blkiocg_reset_stats
>> > o more clarification in the documentation on io_service_time and io_wait_time.
>> >
>> > Signed-off-by: Divyesh Shah<dpshah@google.com>
>>
>> Hi Divyesh,
>>
>> Jens has already applied previous patchset to for-2.6.35 branch, so v3 patchset
>> and this patch have conflicts with for-2.6.35 branch. I think it's better to make
>> new patch on top of for-2.6.35.
>
> Thanks, was just about to ask. Please make an updated patch against what
> I already have, so I don't have to revert/rebase to make this work.

Sure, I'll post an updated patch today.

>
> --
> Jens Axboe
>
>
