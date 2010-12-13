Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0LMQsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:48:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51139 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0LMQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=K6lDdy8xJPXJXh8rP1dXxlX+L0J1QLAFbbWEghwcDwv29A5qaGunBvo/JhBKk5ICnf
         r581w58jjD6url2HT178yVGlCqFEcO9D6r+hYjz+Odezh5bpQJWzKVB39heTY578lMPG
         BGK9f2TQDHrzbDWtupOwfx7h512ih8rwxbWbE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 13 Dec 2010 17:48:18 +0100
Message-ID: <AANLkTim=XVg8fcbAbVJS1bu-Auw7i70AEEH+hoH7tUgS@mail.gmail.com>
Subject: Re: rcu-walk and dcache scaling tree update and status
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I will give this new refreshed patchset a try (testing against
systemd-v15, vfat problem I reported) with none-BKL-config of course.

If linux-next will be the new base, then please rebase on it (see below).
(Last time I solved the CONFLICTs manually).

Regards,
- Sedat -

P.S.:

$ cd /mnt/sdb5/linux-kernel/linux-next

$ git log -1 | cat
commit 455b71004aa0d5cb899dc4df34892265e7486b70
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Dec 13 16:15:19 2010 +1100

    Add linux-next specific files for 20101213

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
vfs-scale-working:vfs-scale-working
remote: Counting objects: 1196, done.
remote: Compressing objects: 100% (80/80), done.
remote: Total 931 (delta 866), reused 915 (delta 851)
Receiving objects: 100% (931/931), 207.90 KiB | 376 KiB/s, done.
Resolving deltas: 100% (866/866), completed with 258 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin
 * [new branch]      vfs-scale-working -> vfs-scale-working
Auto-merging Documentation/filesystems/Locking
Removing Documentation/filesystems/dentry-locking.txt
Auto-merging Documentation/filesystems/vfs.txt
Auto-merging fs/anon_inodes.c
Auto-merging fs/ceph/dir.c
Auto-merging fs/ceph/inode.c
Auto-merging fs/ceph/mds_client.c
Auto-merging fs/cifs/cifsfs.c
Auto-merging fs/cifs/inode.c
Auto-merging fs/cifs/readdir.c
Auto-merging fs/coda/inode.c
Auto-merging fs/ecryptfs/inode.c
Auto-merging fs/ecryptfs/main.c
Auto-merging fs/ext3/super.c
Auto-merging fs/ext4/super.c
Auto-merging fs/fuse/dir.c
Auto-merging fs/fuse/inode.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
Auto-merging fs/gfs2/ops_inode.c
Auto-merging fs/hfsplus/dir.c
Auto-merging fs/hfsplus/hfsplus_fs.h
Auto-merging fs/hfsplus/super.c
Auto-merging fs/namei.c
Auto-merging fs/nfs/dir.c
Auto-merging fs/nfs/inode.c
Auto-merging fs/nfsd/vfs.c
Auto-merging fs/nilfs2/super.c
Auto-merging fs/ocfs2/super.c
Auto-merging fs/proc/base.c
Auto-merging fs/super.c
CONFLICT (content): Merge conflict in fs/super.c
Auto-merging fs/udf/super.c
Auto-merging include/linux/fs.h
Auto-merging include/linux/fsnotify.h
Auto-merging include/linux/fsnotify_backend.h
Auto-merging include/linux/security.h
Auto-merging mm/filemap.c
Auto-merging mm/shmem.c
Auto-merging mm/slab.c
Auto-merging mm/slub.c
Auto-merging net/socket.c
Auto-merging security/selinux/selinuxfs.c
Automatic merge failed; fix conflicts and then commit the result.
- EOT-
