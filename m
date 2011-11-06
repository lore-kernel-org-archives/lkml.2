Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1KFRzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:55:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1KFRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:55:22 -0500
Date: Sun, 6 Nov 2011 19:55:16 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Jan Kiszka <jan.kiszka@web.de>
cc: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
In-Reply-To: <4EB6C299.7000404@web.de>
Message-ID: <alpine.LFD.2.02.1111061954090.1646@tux.localdomain>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com>
 <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6B385.4070804@web.de> <CAOJsxLH5Vgk7tyr=RAEc=S2JhZ7n2JxOiUL9L91P_Bey+AuFUA@mail.gmail.com> <4EB6B83E.8050002@web.de> <alpine.LFD.2.02.1111061906440.1646@tux.localdomain>
 <4EB6C299.7000404@web.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Nov 2011, Jan Kiszka wrote:
> Doesn't help here (with a disk image).
>
> Also, both dependencies make no sense to me as we boot from disk, not
> from net, and the console is on ttyS0.

It's only VIRTIO_NET and the guest is not actually stuck, it just takes a 
while to boot:

[    1.866614] Installing 9P2000 support
[    1.868991] Registering the dns_resolver key type
[    1.878084] registered taskstats version 1
[   13.927367] Root-NFS: no NFS server address
[   13.929500] VFS: Unable to mount root fs via NFS, trying floppy.
[   13.939177] VFS: Mounted root (9p filesystem) on device 0:12.
[   13.941522] devtmpfs: mounted
[   13.943317] Freeing unused kernel memory: 684k freed
Mounting...
Starting '/bin/sh'...
sh-4.2#

I'm CC'ing Sasha and Asias.

