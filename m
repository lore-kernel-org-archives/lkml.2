Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1L3WzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 17:55:10 -0500
Received: from mx2.netapp.com ([216.240.18.37]:5942 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1L3WzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 17:55:06 -0500
X-IronPort-AV: E=Sophos;i="4.71,434,1320652800"; 
   d="scan'208";a="612157807"
Message-ID: <1325285705.10984.4.camel@lade.trondhjem.org>
Subject: Re: [PATCH 0/5] NFS: create blocklayout pipe per network namesapce
 context
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Fri, 30 Dec 2011 17:55:05 -0500
In-Reply-To: <20111129090754.20730.64567.stgit@localhost6.localdomain6>
References: <20111129090754.20730.64567.stgit@localhost6.localdomain6>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 30 Dec 2011 22:55:06.0327 (UTC) FILETIME=[12C26670:01CCC746]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 13:10 +0300, Stanislav Kinsbursky wrote: 
> This patch set was created in context of clone of git
> branch: git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git.
> tag: v3.1
> 
> This patch set depends on previous patch sets titled:
> 1) "SUNRPC: initial part of making pipefs work in net ns"
> 2) "SUNPRC: cleanup PipeFS for network-namespace-aware users"
> 3) "SUNRPC: make RPC clients use network-namespace-aware PipeFS routines"
> 4) "NFS: create clients and IDMAP pipes per network namespace"
> 
> This patch set is the final part of making SUNRPC PipeFS and it's users work in
> network namespace context.
> 
> The following series consists of:
> 
> ---
> 
> Stanislav Kinsbursky (5):
>       NFS: handle blocklayout pipe PipeFS dentry by network namespace aware routines
>       NFS: blocklayout pipe creation per network namespace context introduced
>       NFS: blocklayout PipeFS notifier introduced
>       NFS: remove RPC PipeFS mount point reference from blocklayout routines
>       SUNRPC: kernel PipeFS mount point creation routines removed
> 
> 
>  fs/nfs/blocklayout/blocklayout.c    |  154 ++++++++++++++++++++++++++++-------
>  fs/nfs/blocklayout/blocklayout.h    |    3 -
>  fs/nfs/blocklayout/blocklayoutdev.c |    5 +
>  fs/nfs/blocklayout/blocklayoutdm.c  |    7 +-
>  fs/nfs/inode.c                      |    1 
>  fs/nfs/netns.h                      |    1 
>  include/linux/sunrpc/rpc_pipe_fs.h  |    2 
>  net/sunrpc/rpc_pipe.c               |   21 -----
>  8 files changed, 137 insertions(+), 57 deletions(-)


These patches need rebasing in order to apply on top of 3.2-rc7...

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

