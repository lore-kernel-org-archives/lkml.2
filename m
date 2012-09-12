Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2ILGeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:34:10 -0400
Received: from ozlabs.org ([203.10.76.45]:37264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2ILGda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:33:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, "Michael S . Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv3] virtio_console: Add support for virtio remoteproc serial
In-Reply-To: <1347290307-8155-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com> <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com> <1347290307-8155-1-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 12 Sep 2012 15:30:08 +0930
Message-ID: <87ehm7dbmf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:
> I actually like this new approach better.
> It solves the issues Michael has pointed out, and we don't have to
> think through side effects of weired combination of feature bits.

Agreed.

Just one thing, should it depend on CONFIG_REMOTEPROC?  And have
OMAP_REMOTEPROC depend on CONFIG_HAS_DMA (if it doesn't already).

Thanks,
Rusty.
PS.  I've reserved 11 for you in the latest virtio spec draft.
