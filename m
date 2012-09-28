Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2I1LvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:51:05 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35018 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2I1LvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:51:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVcwAXBYjafnzARN-xkGKGsPC_2Yry-SscaZ_-js-sTiw@mail.gmail.com>
References: <CA+icZUVcwAXBYjafnzARN-xkGKGsPC_2Yry-SscaZ_-js-sTiw@mail.gmail.com>
Date: Fri, 28 Sep 2012 13:51:00 +0200
Message-ID: <CA+icZUWNWnKu9YiR8Vs6J26LFi=u2VL14_ZYh_pEYONaEPddxg@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 28 (ext4|vfs related issues?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 1:22 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Sep 28, 2012 at 8:51 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 201209027:
>>
>> The vfs tree lost its conflicts.
>>
>> The infiniband tree gained a conflict against Linus' tree.
>>
>> The net-next tree gained a conflict against the net tree and a build
>> failure for which I reverted a commit.
>>
>> The block tree lost its build failure.
>>
>> The tip tree gained conflicts against the rr tree.
>>
>> The signal tree gained a conflict against the vfs tree.
>>
>> The akpm tree lost several patches that turned up elsewhere and lost its
>> build failure but gained another for which I applied a merge fix patch.
>>
>> ----------------------------------------------------------------------------
>>
>
> [ Added some more maintainers of ext4|vfs|block ]
>
> Hi,
>
> after solving the thermal-next problem (patch still pending in thermal
> tree) today's Linux-Next is still not running fine here (I reported
> that already).
>
> After switching from SLUB to SLAB I could take finally a screenshot of
> a call-trace (sorry, it's 600KiB).
> It seems to be a problem of Ext4-FS or in combination with VFS (can't
> say as I am not an FS-expert).
> Symptoms:
> Harddisk I/O is fu**ing slow, apps like firefox start slowly as used
> to and stall often, a dmesg-output in a console takes sometimes ages,
> etc.
> IOW, you cannot work on such a system :-)!
>
> Hope the screenshot helps to dig down the problem.
>

I pulled in latest ext4.git#dev [0] and [1] seems to be the pending fix.
Still compiling... (will report later on).

- Sedat -

[0] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=refs/heads/dev
[1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=9bebbf9b6266e63a68845ade39e368f2d162ea1c

> Regards,
> - Sedat -
>
> P.S.: I also attached the latest kernel-config.
