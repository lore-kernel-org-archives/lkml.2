Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0KLSST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:18:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45454 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:18:18 -0500
MIME-Version: 1.0
In-Reply-To: <87fwv6sbwr.fsf@gmail.com>
References: <87fwv6sbwr.fsf@gmail.com>
Date: Fri, 12 Nov 2010 19:18:17 +0100
Message-ID: <AANLkTim9bVVd3=Q3UsmdJBFeFX_YvaXgmgs8Hq5NdeR7@mail.gmail.com>
Subject: Re: Mounting blkio cgroup hierarchy
From: Dhaval Giani <dhaval.lists@thegianis.in>
To: Ben Gamari <bgamari@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        libcg-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 6:13 PM, Ben Gamari <bgamari@gmail.com> wrote:
> I've been trying to configure cgroups and have encountered some very
> strange behavior. In particular, when I follow the instructions in
> Documentation/cgroups/blkio-controller.txt I quickly reach an error,
>
> $ cd /mnt
> $ sudo mkdir -p cgroups/blkio
> $ # Confirm it's not already mounted:
> $ cat /proc/mounts
> rootfs / rootfs rw 0 0
> none /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> none /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> none /dev devtmpfs rw,relatime,size=1993264k,nr_inodes=498316,mode=755 0 0
> none /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
> /dev/disk/by-uuid/7d908a9f-fe46-4a82-bb2b-3fc108c96280 / ext4 rw,relatime,errors=remount-ro,barrier=1,data=ordered 0 0
> none /sys/kernel/debug debugfs rw,relatime 0 0
> none /sys/kernel/security securityfs rw,relatime 0 0
> none /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
> none /var/run tmpfs rw,nosuid,relatime,mode=755 0 0
> none /var/lock tmpfs rw,nosuid,nodev,noexec,relatime 0 0
> /dev/sda1 /boot ext4 rw,relatime,barrier=1,data=ordered 0 0
> binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,relatime 0 0
> gvfs-fuse-daemon /home/ben/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
> $ sudo mount -t cgroup -o blkio none /mnt/cgroups/blkio
> mount: special device none does not exist
>
> I've done quite a bit of Googling and yet it's very difficult to find
> good information on configuring cgroups. I would use the libcg
> toolset[1] but every attempt to configure it has ended in frustratingly
> vague error messages.
>

If you give us a hint with what error messages you are getting, at the
very least we can work on fixing those up :-)

Dhaval
