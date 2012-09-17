Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2IQLgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:36:08 -0400
Received: from ozlabs.org ([203.10.76.45]:44406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab2IQLgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:36:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH repost] virtio: don't crash when device is buggy
In-Reply-To: <20120916094427.GA24075@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com> <20120903143018.GA5353@redhat.com> <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com> <20120903202737.GD6181@redhat.com> <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com> <20120904135022.GI9805@redhat.com> <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com> <20120904185541.GB3602@redhat.com> <87k3w7j49i.fsf@rustcorp.com.au> <20120916094427.GA24075@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 17 Sep 2012 13:57:17 +0930
Message-ID: <87ehm1s28q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Because of a sanity check in virtio_dev_remove, a buggy device can crash
> kernel.  And in case of rproc it's userspace so it's not a good idea.
> We are unloading a driver so how bad can it be?
> Be less aggressive in handling this error: if it's a driver bug,
> warning once should be enough.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> --
>
> 3.6 material?

I have already applied, this, but it's not for stable, since it's a
"theoretical bugfix".  That check has been in there forever and noone
AFAIK has actually struck it.

Cheers,
Rusty.
