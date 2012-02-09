Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2BIGWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:22:34 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61810 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2BIGWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120208162925.GA19392@google.com>
References: <20120206172706.GB21292@google.com>
	<4F303506.9000201@kernel.dk>
	<20120206215451.GD21292@google.com>
	<4F30C96F.1000905@kernel.dk>
	<20120207162253.GG21292@google.com>
	<4F315113.5010804@kernel.dk>
	<CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
	<20120207164735.GH21292@google.com>
	<CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
	<CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
	<20120208162925.GA19392@google.com>
Date: Thu, 9 Feb 2012 14:22:32 +0800
X-Google-Sender-Auth: f7x7yrzaLLZbZy4VLNmv6XBUkdY
Message-ID: <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/9 Tejun Heo <tj@kernel.org>:
> Hello, Shaohua.
>
> On Wed, Feb 08, 2012 at 04:29:53PM +0800, Shaohua Li wrote:
>> > the test adds mem=4G in a 2 sockets 16 CPU machine.
>> > just make several copy of kernel source in tmpfs (so there is swap
>> > depending on your
>> > memory size) and run kernel build in the kernel source in the meaning time.
>> > there is only one swap device which is a rotating disk.
>> >
>> > I'll test both patches soon.
>>
>> Tried all the options, the regression still exists. Any new idea?
>> I'll spend some time on it if I can get anything
>
> Can you please try the following one?  Thanks a lot!
doesn't work.
I also double confirmed b2efa05265d62 causes the regression
