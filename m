Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2IDXKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:10:25 -0400
Received: from ozlabs.org ([203.10.76.45]:56891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab2IDXKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:10:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
In-Reply-To: <20120903202737.GD6181@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com> <20120903143018.GA5353@redhat.com> <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com> <20120903202737.GD6181@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 04 Sep 2012 15:37:43 +0930
Message-ID: <87zk56e2xc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Also let's add a wrapper at top of file so ifdefs
> do not litter the code like this. For example:
>
> #ifdef CONFIG_HAS_DMA
> #define VIRTIO_CONSOLE_HAS_DMA (1)
> #else
> #define VIRTIO_CONSOLE_HAS_DMA (0)
> #endif
>
> Now use if instead of ifdef.

The driver certainly shouldn't offer VIRTIO_CONSOLE_F_DMA_MEM if you
don't have DMA!

Cheers,
Rusty.
