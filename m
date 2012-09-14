Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2INHDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:03:06 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:37855 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2INHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:03:03 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2012 03:03:03 EDT
X-CTCH-RefID: str=0001.0A0B020D.5052D51E.0012,ss=1,re=0.000,fgs=0
Message-ID: <5052D51D.3060106@bmw-carit.de>
Date: Fri, 14 Sep 2012 08:56:29 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: linux-next: build failure after merge of the cgroup tree
References: <20120914131700.dd3d01a7d17b78082a9bcd55@canb.auug.org.au>
In-Reply-To: <20120914131700.dd3d01a7d17b78082a9bcd55@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 14.09.2012 05:17, Stephen Rothwell wrote:
> Hi Tejun,
>
> After merging the cgroup tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/net/tun.c: In function 'tun_alloc_skb':
> drivers/net/tun.c:589:2: error: implicit declaration of function 'sock_update_classid' [-Werror=implicit-function-declaration]
>
> Caused by commit 1f66c0a8833c ("cgroup: net_cls: Move sock_update_classid()
> declaration to cls_cgroup.h").  Grep is your friend ...

Sorry about missing to update tun.c. I *swear* I used grep to search
for sock_update_classid() users. It is not the tool's fault when my
brain is not able to decode the things it wants to tell me.

> I have used the cgroup tree from next-20120913 for today.

Obviously, it is straight forward to fix this but I do not know what is 
the preferred solution. Shall I spin an updated version of this patch or 
add a patch on top of the series?

sorry again,
daniel

