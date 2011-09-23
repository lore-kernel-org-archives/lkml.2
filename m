Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab1IWRii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:38:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51197 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1IWRig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <1316788285-17433-8-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-8-git-send-email-philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 23 Sep 2011 13:38:15 -0400
Message-ID: <CAGZ=bq+XQNGEU1HHBEMWdc-hg-B-=eoKNYobUeGrZeeSq41M_A@mail.gmail.com>
Subject: Re: [PATCH 07/10] drbd: Remove headers from on-the-wire data
 structures (struct p_*)
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Sep 23, 2011 at 10:31, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> From: Andreas Gruenbacher <agruen@linbit.com>
>
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> ---
>  drivers/block/drbd/drbd_int.h      |   45 ----------
>  drivers/block/drbd/drbd_main.c     |   44 +++++-----
>  drivers/block/drbd/drbd_receiver.c |  171 ++++++++++++++++++------------------
>  drivers/block/drbd/drbd_worker.c   |    2 +-

This commit is kind of borderline too-big for just a one-line commit message.

It is admittedly very simple (changing the same pointer math in ~50 places),
but it needs a bit more explanation about why it's helpful or necessary.

I *think* it's because the protocol-100 code will use a different-sized header,
but that needs to be actually explained somewhere.

Cheers,
Kyle Moffett
