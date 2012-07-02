Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab2GBNjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:39:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61795 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBNjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <1341229532.29646.39.camel@gurkel.linbit>
References: <1340981632.25226.2.camel@gurkel.linbit> <1340982523.21162.1.camel@edumazet-glaptop>
 <1341229532.29646.39.camel@gurkel.linbit>
From: saeed bishara <saeed.bishara@gmail.com>
Date: Mon, 2 Jul 2012 16:39:28 +0300
Message-ID: <CAMAG_eeDXghHXYxBXK08cweimvdFVr_vCk2f47_OHGZgux7zuw@mail.gmail.com>
Subject: Re: [RFC] [TCP 0/3] Receive from socket into bio without copying
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 2:45 PM, Andreas Gruenbacher <agruen@linbit.com> wrote:

>
> We want to go directly to the block layer instead.  This requires that
> the network hardware receives the data into sector aligned buffers.
> Hence the proposed MSG_NEW_PACKET flag.
Andreas,
 I didn't read your patches, but what are you looking for can't be
achieved using "normal" NICs, for that you need to use RDMA protocol
with a hardware that supports RDMA.

saeed
