Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1I2PP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:15:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58749 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1I2PPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110929155557.1baa18a46e6dc142a97cf1d0@canb.auug.org.au>
References: <20110929155557.1baa18a46e6dc142a97cf1d0@canb.auug.org.au>
Date: Thu, 29 Sep 2011 11:15:24 -0400
X-Google-Sender-Auth: pkc8w1jUjRQ9tYiECAQl1L9bqdI
Message-ID: <CAP=VYLp0zFMGtu2mTOvt5avyeGXQYD2NV=2z=anE1RwwyUw7SQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the staging tree
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 1:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/staging/iio/accel/adis16220_core.c between commits 7991029a55fa
> ("staging:iio:accel:adis16220 iio_chan_spec conversion") and 6f4ebab56870
> ("staging: iio: adis16220_core.c: add module.h") from the staging tree
> and commit 6eee8b750254 ("staging: Add module.h to more drivers
> implicitly using it") from the moduleh tree.
>
> The staging commits are a superset of the part of the moduleh commit that
> affects this file, so I dropped the moduleh change (module.h was added in
> different places).

Yep, I'll drop that change; it got re-added when I re-did build testing on the
baseline v3.1-rc6+module.h and saw a build failure.  I didn't clue into that
even when I got the same conflict on my test merge with -next content...

Thanks,
Paul.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
