Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1LMHVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:21:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62514 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1LMHVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:21:18 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
In-Reply-To: <1323760467.11759.2.camel@phoenix>
References: <1323760467.11759.2.camel@phoenix>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 13 Dec 2011 09:20:57 +0200
Message-ID: <CAK=WgbY2Kw0G7OkkN6f7=rExFpBzHVy_7r1xCrHe02nSuOUC3Q@mail.gmail.com>
Subject: Re: [PATCH] rpmsg: rename virtqueue_add_buf_gfp to virtqueue_add_buf
To: Axel Lin <axel.lin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 9:14 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Since commit 7bb7aef2 "virtio: rename virtqueue_add_buf_gfp to virtqueue_add_buf",
> virtqueue_add_buf_gfp is renamed to virtqueue_add_buf now.
>
> This patch fixes below build error:
>  CC [M]  drivers/rpmsg/virtio_rpmsg_bus.o
> drivers/rpmsg/virtio_rpmsg_bus.c: In function 'rpmsg_send_offchannel_raw':
> drivers/rpmsg/virtio_rpmsg_bus.c:723: error: implicit declaration of function 'virtqueue_add_buf_gfp'
> make[2]: *** [drivers/rpmsg/virtio_rpmsg_bus.o] Error 1
> make[1]: *** [drivers/rpmsg] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error on linux-next 20111212.
> So this patch is against linux-next.

Thanks a lot for the heads up, Axel !

Stephen, can you please carry this patch in linux-next ?

Thanks!
Ohad.
