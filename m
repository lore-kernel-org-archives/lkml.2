Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab1IWReJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:34:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43248 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1IWReG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <1316788285-17433-5-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-5-git-send-email-philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 23 Sep 2011 13:33:45 -0400
Message-ID: <CAGZ=bqJ_b54h9xid_PNwz-Ag6aNuvyUHx2QCm5UXpdc-JvHhKQ@mail.gmail.com>
Subject: Re: [PATCH 04/10] drbd: Replace and remove old primitives
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
>  drivers/block/drbd/drbd_int.h      |   45 +----
>  drivers/block/drbd/drbd_main.c     |  502 ++++++++++++++++--------------------
>  drivers/block/drbd/drbd_receiver.c |   86 ++++---
>  drivers/block/drbd/drbd_worker.c   |   24 +-
>  4 files changed, 294 insertions(+), 363 deletions(-)

I'm afraid this commit is waaaaay too large and complicated
to have a one-line commit message.

You should either split this up into more pieces or you should
write a detailed log indicated what this is supposed to be doing
and why it is OK.  (Or both).

Cheers,
Kyle Moffett
