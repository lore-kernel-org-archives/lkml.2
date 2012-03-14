Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847Ab2CNNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:22:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030816Ab2CNNWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:22:17 -0400
MIME-Version: 1.0
In-Reply-To: <1331694008.2293.10.camel@firefly>
References: <1331694008.2293.10.camel@firefly>
Date: Wed, 14 Mar 2012 09:22:17 -0400
Message-ID: <CA+5PVA64+mwTTWwC9bDqd8ksCmNgn-n-9XyAD+ogL3UA2GiRyw@mail.gmail.com>
Subject: Re: Oops with kernel 3.3-rc7
From: Josh Boyer <jwboyer@gmail.com>
To: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:00 PM, Nathan A. Mourey II
<nmoureyii@ne.rr.com> wrote:
> Hello All,
>        I have had another oops to report.  I am using btrfs as my root file
> system.  It was originally ext4 that I converted to btrfs.  I also
> had /home on a separate partition but deleted it and extended my root
> partition then grew the root file system with "btrfs filesystem resize"
> My /boot partition is ext2.  Please feel free to email me with any
> questions.
>
> TIA -- Nate
>
> [   12.678120] hub 4-0:1.0: port 1, status 0100, change 0000, 12 Mb/s
> [   12.678126] usb 4-1: USB disconnect, device number 2
> [   12.678130] usb 4-1: unregistering device
> [   12.678134] usb 4-1: unregistering interface 4-1:1.0
> [   12.680983] scsi 3:0:0:2: killing request
> [   12.681625] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   12.682009] IP: [<c1425553>] sd_revalidate_disk+0x13/0x1fa0
> [   12.682717] *pde = 00000000
> [   12.683765] Oops: 0000 [#1] SMP
> [   12.684850] Modules linked in: ehci_hcd
> [   12.684850]
> [   12.684850] Pid: 1120, comm: blkid Not tainted 3.3.0-rc7 #1 HP Pavilion 061 DM170A-ABA A350N/'P4SD-LA'
> [   12.684850] EIP: 0060:[<c1425553>] EFLAGS: 00010292 CPU: 0
> [   12.684850] EIP is at sd_revalidate_disk+0x13/0x1fa0

There have been patches submitted to fix this already.  I believe we're
waiting on Jens to push them to Linus.  You can find them here:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-block.git;a=shortlog;h=refs/heads/for-linus

Jens, is there some reason you haven't pushed those yet?

josh
