Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1DSJjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:39:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1DSJjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TCcKuWjVCWYMFSPj5F9WtcHRcRPp1ePkmQ5B7ZLjDGXFA4PuLqvJubpr5rbCSxpPfm
         vuqxw2E7znBBuYQvP7rRGSnv0QExijgosDPZykvZ4LmSK9N5Hn5bVoITU18NJhDqRxE8
         dhASsdokU980OsYtOtnOzzGbGpCSL6rz9tIjY=
MIME-Version: 1.0
X-Originating-IP: [80.98.43.182]
In-Reply-To: <BANLkTin9OP7JA-CUAezFNyhYRWB9_NXf0A@mail.gmail.com>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
	<BANLkTin9OP7JA-CUAezFNyhYRWB9_NXf0A@mail.gmail.com>
Date: Tue, 19 Apr 2011 11:39:39 +0200
Message-ID: <BANLkTimp9Y7+TbK-DYBketCbuW61643Srg@mail.gmail.com>
Subject: Re: [PATCH 0/6] overlay filesystem
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 8:19 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 18 April 2011 18:00, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Here's an updated version of the overlay filesystem.
>>
>> Git tree is here:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v8
>>
>
> Can't build this one:
>
>
>  CC [M]  fs/overlayfs/copy_up.o
>  CC [M]  fs/qnx4/inode.o
> fs/overlayfs/copy_up.c: In function 'ovl_read_symlink':
> fs/overlayfs/copy_up.c:135: error: implicit declaration of function 'get_fs'
> fs/overlayfs/copy_up.c:135: error: incompatible types when assigning
> to type 'mm_segment_t' from type 'int'
> fs/overlayfs/copy_up.c:136: error: implicit declaration of function 'set_fs'
> fs/overlayfs/copy_up.c:136: error: implicit declaration of function 'get_ds'

Thanks.   Fixed in the overlayfs.v8 branch.  Also patches coming up.

Miklos
