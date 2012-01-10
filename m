Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2AJKuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:50:18 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28587 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab2AJKuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:50:16 -0500
Message-ID: <4F0C17E2.6030003@parallels.com>
Date: Tue, 10 Jan 2012 14:50:10 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/5] NFS: create blocklayout pipe per network namesapce
 context
References: <20111129090754.20730.64567.stgit@localhost6.localdomain6> <1325285705.10984.4.camel@lade.trondhjem.org>
In-Reply-To: <1325285705.10984.4.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.12.2011 02:55, Trond Myklebust пишет:
> On Tue, 2011-11-29 at 13:10 +0300, Stanislav Kinsbursky wrote:
>> This patch set was created in context of clone of git
>> branch: git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git.
>> tag: v3.1
>>
>> This patch set depends on previous patch sets titled:
>> 1) "SUNRPC: initial part of making pipefs work in net ns"
>> 2) "SUNPRC: cleanup PipeFS for network-namespace-aware users"
>> 3) "SUNRPC: make RPC clients use network-namespace-aware PipeFS routines"
>> 4) "NFS: create clients and IDMAP pipes per network namespace"
>>
>> This patch set is the final part of making SUNRPC PipeFS and it's users work in
>> network namespace context.
>>
>> The following series consists of:
>>
>> ---
>>
>> Stanislav Kinsbursky (5):
>>        NFS: handle blocklayout pipe PipeFS dentry by network namespace aware routines
>>        NFS: blocklayout pipe creation per network namespace context introduced
>>        NFS: blocklayout PipeFS notifier introduced
>>        NFS: remove RPC PipeFS mount point reference from blocklayout routines
>>        SUNRPC: kernel PipeFS mount point creation routines removed
>>
>>
>>   fs/nfs/blocklayout/blocklayout.c    |  154 ++++++++++++++++++++++++++++-------
>>   fs/nfs/blocklayout/blocklayout.h    |    3 -
>>   fs/nfs/blocklayout/blocklayoutdev.c |    5 +
>>   fs/nfs/blocklayout/blocklayoutdm.c  |    7 +-
>>   fs/nfs/inode.c                      |    1
>>   fs/nfs/netns.h                      |    1
>>   include/linux/sunrpc/rpc_pipe_fs.h  |    2
>>   net/sunrpc/rpc_pipe.c               |   21 -----
>>   8 files changed, 137 insertions(+), 57 deletions(-)
>
>
> These patches need rebasing in order to apply on top of 3.2-rc7...
>

Will resend rebased version soon.

-- 
Best regards,
Stanislav Kinsbursky
