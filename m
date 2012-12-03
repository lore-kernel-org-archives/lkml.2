Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2LCWUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:20:48 -0500
Received: from stringer.orebokech.com ([88.190.240.207]:35191 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LCWUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:20:47 -0500
From: Romain Francoise <romain@orebokech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.7-rc8
Organization: orebokech dot com
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
Date: Mon, 03 Dec 2012 23:20:45 +0100
In-Reply-To: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 3 Dec 2012 12:36:26 -0800")
Message-ID: <874nk2u69u.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Linus Torvalds (5):
>       fs/buffer.c: make block-size be per-page and protected by the page lock
>       blockdev: remove bd_block_size_semaphore again
>       direct-io: don't read inode->i_blkbits multiple times
>       blkdev_max_block: make private to fs/buffer.c

Could these changes be the reason for the following suddenly appearing in
one of my VMs with rc8 (no such messages with rc7)? Pretty standard virtio
setup in KVM.

[   11.832295] attempt to access beyond end of device
[   11.832298] vda1: rw=0, want=4192904, limit=4192902
[   11.832299] Buffer I/O error on device vda1, logical block 524112
[   11.832394] attempt to access beyond end of device
[   11.832395] vda1: rw=0, want=4192904, limit=4192902
[   11.832396] Buffer I/O error on device vda1, logical block 524112

Thanks.
