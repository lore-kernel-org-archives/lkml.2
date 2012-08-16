Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab2HPT6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:58:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61054 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2HPT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:58:36 -0400
Date: Thu, 16 Aug 2012 12:58:31 -0700
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Message-ID: <20120816195831.GF24861@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816174453.507922179@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:44:54PM -0400, aris@redhat.com wrote:
> From: Li Zefan <lizefan@huawei.com>
> 
> Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.
> 
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658782  880729 5195032 10734543         a3cbcf vmlinux.o
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658957  880729 5195032 10734718         a3cc7e vmlinux.o
> 
> v6:
> - no changes
> v5:
> - no changes
> v4:
> - move simple_xattrs_free() to fs/xattr.c
> v3:
> - in kmem_xattrs_free(), reinitialize the list
> - use simple_xattr_* prefix
> - introduce simple_xattr_add() to prevent direct list usage
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>

Hugh, can you please review and ack this one?

Thanks.

-- 
tejun
