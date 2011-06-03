Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1FCMZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:25:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57751 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1FCMZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ll1Dh14qhWOtvnRG2PU77hvjCRy4PUoLdXA0iSqH6KpXsBfY58QrDGuT7T1a3XDZpK
         FL6MguhdjaEnUiMvN7CEu8LVn4blCA+wH8WElKyS/GFNPBMiaTQJ4NzXh4fUIhPidqIN
         akFkKPn26VpUaBmeFUanZKKEBkwFqSmeygSoI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
Date: Fri, 3 Jun 2011 14:25:34 +0200
Message-ID: <BANLkTim-0xj7Pr2EkZs2JEkyVw_7F9eM=g@mail.gmail.com>
Subject: Re: linux-next: build warninga in Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the Linus' tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
>
> fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
> fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
> fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
> fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used
>
> I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
> difference.

I see the same warnings with Debian's gcc-4.6 (here: next-20110603),
plus some more:

fs/btrfs/ioctl.c: In function 'btrfs_ioctl_fs_info.isra.24':
fs/btrfs/ioctl.c:2080:1: warning: the frame size of 1032 bytes is
larger than 1024 bytes [-Wframe-larger-than=]

fs/btrfs/delayed-inode.c: In function 'btrfs_batch_insert_items':
fs/btrfs/delayed-inode.c:690:9: warning: 'nitems' may be used
uninitialized in this function [-Wuninitialized]

- Sedat -

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
