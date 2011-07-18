Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1GRGHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 02:07:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1GRGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 02:07:50 -0400
Message-ID: <4E23CD7C.30902@cn.fujitsu.com>
Date: Mon, 18 Jul 2011 14:06:52 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs
 utilities in Documentation/filesystems/btrfs.txt
References: <4E23BC5F.4060200@gmail.com>
In-Reply-To: <4E23BC5F.4060200@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-18 14:06:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-18 14:07:00,
	Serialize complete at 2011-07-18 14:07:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 12:53 PM, Wang Sheng-Hui wrote:
> The patch is against 3.0-rc7 kernel.
>
>> From d22497ac8c5dd55a2ef9a47de5f2ddee55f8ec50 Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui<shhuiw@gmail.com>
> Date: Sun, 17 Jul 2011 21:45:01 -0500
> Subject: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs utilities in Documentation/filesystems/btrfs.txt
>
> git repository link for btrfs utilities
>     http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
> doesn't work, and git-clone can get failed as:
> $ git clone
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
> Initialized empty Git repository in
> /home/crossover/dev/btrfs-progs-unstable/.git/
> fatal:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git/info/refs not found: did you run git update-server-info on the server?
>
> Update git repository links for btrfs utilities to the latest ones
> in Documentation/filesystems/btrfs.txt
>
> Signed-off-by: Wang Sheng-Hui<shhuiw@gmail.com>
> ---
>   Documentation/filesystems/btrfs.txt |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index 64087c3..b095261 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -63,8 +63,9 @@ IRC network.
>   Userspace tools for creating and manipulating Btrfs file systems are
>   available from the git repository at the following location:
>
> - http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
It's the right git-web URL.
>    git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> + http://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> + https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
>
>   These include the following tools:
>


-- 
Thanks
Best Regards
Wanlong Gao
