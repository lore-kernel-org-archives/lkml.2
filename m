Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1LSJqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:46:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41011 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1LSJqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:46:01 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
References: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au>
Date: Mon, 19 Dec 2011 10:45:58 +0100
Message-ID: <CA+icZUWrpTFPhM0cTQgvBPnMqT3zZufcxQ6c6wh7=EtkD4of9w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the block tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI:

- block           git     git://git.kernel.dk/linux-2.6-block.git#for-next
+ block           git     git://git.kernel.dk/linux-block.git#for-next

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees#l130
[2] http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/for-next

On Mon, Dec 19, 2011 at 4:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jens,
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "ioc_cgroup_changed" [block/blk-cgroup.ko] undefined!
>
> Caused by commit dc86900e0a8f ("block, cfq: move ioc ioprio/cgroup
> changed handling to cic").
>
> I have used the block tree from next-20111215 again today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
