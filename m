Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1LGIka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:40:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42453 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1LGIk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:40:28 -0500
MIME-Version: 1.0
X-Originating-IP: [62.165.247.249]
In-Reply-To: <CAJfpeguawQGYvL+tDD-mgxjyZPVbJs04tug853H0yLn7MyfLig@mail.gmail.com>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
	<CAJfpeguawQGYvL+tDD-mgxjyZPVbJs04tug853H0yLn7MyfLig@mail.gmail.com>
Date: Wed, 7 Dec 2011 09:40:27 +0100
Message-ID: <CAJfpegt76t=kn4k73ASrvUMyJJxhF=nPYMTz1JVLbRVRAkW5uw@mail.gmail.com>
Subject: Re: [PATCH 0/4] read-only remount race fix v10
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:39 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 21, 2011 at 12:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Al,
>>
>> Please apply the following patches that fix read-only remount races.
>>
>> Git tree is here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes.v10

Al, what's up with this?  Am I on your block list?  Or bug fixes for
the VFS are no longer interesting?  Or what?

Thanks,
MIklos

>> ---
>> Miklos Szeredi (4):
>>      vfs: keep list of mounts for each superblock
>>      vfs: protect remounting superblock read-only
>>      vfs: count unlinked inodes
>>      vfs: prevent remount read-only if pending removes
>>
>> ---
>>  fs/file_table.c       |   23 -------------
>>  fs/inode.c            |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/internal.h         |    1 +
>>  fs/namespace.c        |   57 ++++++++++++++++++++++++++++++++-
>>  fs/super.c            |   20 +++++++++--
>>  include/linux/fs.h    |   67 ++++++--------------------------------
>>  include/linux/mount.h |    1 +
>>  7 files changed, 170 insertions(+), 84 deletions(-)
>>
>>
