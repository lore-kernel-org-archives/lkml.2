Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab2INOuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:50:22 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:35524 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab2INOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:50:20 -0400
Message-ID: <5053442A.7040801@monom.org>
Date: Fri, 14 Sep 2012 16:50:18 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>,
        Rick Jones <rick.jones2@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Tejun Heo <tj@kernel.org>, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] cgroup: net_cls: Include missing header with sock_update_classid()
 definition
References: <1347633184-26837-1-git-send-email-wagi@monom.org> <1347633184-26837-3-git-send-email-wagi@monom.org> <CA+icZUUrdGgUM32r88EyRHEb3Q6bULqnk74PikQ8A9q25ZA3NA@mail.gmail.com>
In-Reply-To: <CA+icZUUrdGgUM32r88EyRHEb3Q6bULqnk74PikQ8A9q25ZA3NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On 14.09.2012 16:43, Sedat Dilek wrote:
> On Fri, Sep 14, 2012 at 4:33 PM, Daniel Wagner <wagi@monom.org> wrote:
>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>
>> commit 1f66c0a8833c3974ab6b35edcf4f8585b2f94592
>> Author: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> Date:   Wed Sep 12 16:12:01 2012 +0200
>>
>>      cgroup: net_cls: Move sock_update_classid() declaration to cls_cgroup.h
>>
>> Claimed that there was only net/socket.c depending on
>> sock_update_class(). That is not true drivers/net/tun.c needs to
>> include the cls_cgroup.h header too.
>>
>> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Gao feng <gaofeng@cn.fujitsu.com>
>> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>> Cc: Joe Perches <joe@perches.com>
>> Cc: John Fastabend <john.r.fastabend@intel.com>
>> Cc: Li Zefan <lizefan@huawei.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Rick Jones <rick.jones2@hp.com>
>> Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Cc: cgroups@vger.kernel.org
>> ---
>>
>> This version is on top of the latest cgroup for-3.7 branch.
>>
>
> Thanks for the quick fix.

No problem. I am still ashamed not finding it myself.

> Please honour Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>.

Sure, will do next time.

> If this is the fix for the breakage in today's Linux-Next
> (next-20120914), please add a "-next" to the subject next time.

Correct, this one is for linux-next but I got the impression that cgroup 
for-3.7 branch was ignored because of this. Therefore I have send two 
versions. Hmm, I'll need to check the results of todays next tree.

thanks,
daniel

