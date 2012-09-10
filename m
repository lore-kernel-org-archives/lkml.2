Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2IJIEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:04:37 -0400
Received: from ozlabs.org ([203.10.76.45]:42013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab2IJIEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:04:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, "Michael S . Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 1/2] virtio_console: Add support for DMA memory allocation
In-Reply-To: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 10 Sep 2012 17:23:52 +0930
Message-ID: <87zk4ye2jz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:

> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add feature VIRTIO_CONSOLE_F_DMA_MEM. If the architecture has
> DMA support and this feature bit is set, the virtio data buffers
> will be allocated from DMA memory. If the device requests
> the feature VIRTIO_CONSOLE_F_DMA_MEM, but the architecture
> don't support DMA the driver's probe function will fail.
>
> This is needed for using virtio_console from the remoteproc
> framework.

Sorry for the back and forth, I've been pondering MST's points.

If we make a new dma-multiport device (eg. ID 11), how ugly is the code?

It would be a virtio console with DMA buffers and no console, just the
multiport stuff.  This would have no impact on the current spec for
virtio console.

Thanks,
Rusty.
