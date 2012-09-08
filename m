Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2IHTsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:48:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57408 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab2IHTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
Date: Sat, 8 Sep 2012 22:48:22 +0300
Message-ID: <CAJZOPZKWfQ7J4i26mv-19v+T2hu_9vuYw72O_7BJ4wbSnUUAbg@mail.gmail.com>
Subject: Re: [PATCH fixes/for-3.6 0/3] few more IB fixes for 3.6
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 6:14 PM, Or Gerlitz <ogerlitz@mellanox.com> wrote:

> Hi Roland,
>
> This short series include two more fixes from Shlomo to the newly
> introduced IPoIB neighbour table, and a fix for Yishai that completes
> the support for memory registration of up to 8TB.

Roland,

AFAIK 3.6-rc5 should be out by tonight, these are fixes to known bugs
in there which I sent you eleven days ago and didn't get any comment,
could you get them in and/or react in some way?

thanks,

Or.

>
> Shlomo Pongratz (2):
>   IB/ipoib: Fix memory leak in the neigh table deletion flow
>   IB/ipoib: Fix AB-BA deadlock when deleting neighbours
>
> Yishai Hadas (1):
>   net/mlx4_core: Enable 8TB memory registration
>
>  drivers/infiniband/ulp/ipoib/ipoib.h           |    4 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |  101 +++++++++++------------
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 -
>  drivers/net/ethernet/mellanox/mlx4/icm.c       |   30 ++++---
>  drivers/net/ethernet/mellanox/mlx4/icm.h       |   10 +-
>  5 files changed, 74 insertions(+), 73 deletions(-)
