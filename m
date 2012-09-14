Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737Ab2INScc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:32:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53833 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2INSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:32:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120914170019.GA17747@google.com>
References: <20120914131700.dd3d01a7d17b78082a9bcd55@canb.auug.org.au>
	<5052D51D.3060106@bmw-carit.de>
	<20120914170019.GA17747@google.com>
Date: Fri, 14 Sep 2012 20:32:28 +0200
Message-ID: <CA+icZUWrK10WmS1252kCPMKxfjihz3z5xqvXPGB1Oi13MuOJfw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cgroup tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 7:00 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Sep 14, 2012 at 08:56:29AM +0200, Daniel Wagner wrote:
>> On 14.09.2012 05:17, Stephen Rothwell wrote:
>> >After merging the cgroup tree, today's linux-next build (powerpc
>> >ppc64_defconfig) failed like this:
>> >
>> >drivers/net/tun.c: In function 'tun_alloc_skb':
>> >drivers/net/tun.c:589:2: error: implicit declaration of function 'sock_update_classid' [-Werror=implicit-function-declaration]
>> >
>> >Caused by commit 1f66c0a8833c ("cgroup: net_cls: Move sock_update_classid()
>> >declaration to cls_cgroup.h").  Grep is your friend ...
>
> My apologies.  Forgot allmod build.
>
>> >I have used the cgroup tree from next-20120913 for today.
>>
>> Obviously, it is straight forward to fix this but I do not know what
>> is the preferred solution. Shall I spin an updated version of this
>> patch or add a patch on top of the series?
>
> I fixed the commit in tree.
>
> Thanks.
>

Did you pushed this to [1] already?

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/tj/cgroup.git;a=shortlog;h=refs/heads/for-next

> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
