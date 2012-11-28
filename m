Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2K1DGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:06:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2K1DGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <1354069667.BsTEhItmLz@vostro.rjw.lan>
References: <1353761958-12810-1-git-send-email-ming.lei@canonical.com>
	<1353761958-12810-6-git-send-email-ming.lei@canonical.com>
	<1354069667.BsTEhItmLz@vostro.rjw.lan>
Date: Wed, 28 Nov 2012 11:06:43 +0800
Message-ID: <CACVXFVOAt8hrNenEthRZEqv2d6g+gzSPUCBV=RU_u=bxs+9VTw@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] PM / Runtime: force memory allocation with no I/O
 during Runtime PM callbcack
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 5:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Please don't duplicate code this way.
>
> You can move that whole thing to rpm_callback().  Yes, you'll probably need to
> check dev->power.memalloc_noio twice in there, but that's OK.

Good idea, I will update it in v7.

Thanks,
--
Ming Lei
