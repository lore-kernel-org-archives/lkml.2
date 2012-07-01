Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2GACP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 22:15:56 -0400
Received: from seven.medozas.de ([5.9.24.206]:51527 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2GACPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 22:15:55 -0400
Date: Sun, 1 Jul 2012 04:15:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Vincent Sanders <vincent.sanders@collabora.co.uk>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH net-next 06/15] netfilter: Add NFPROTO_BUS hook constant
 for AF_BUS socket family
In-Reply-To: <1340988354-26981-7-git-send-email-vincent.sanders@collabora.co.uk>
Message-ID: <alpine.LNX.2.01.1207010411200.12387@frira.zrqbmnf.qr>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <1340988354-26981-7-git-send-email-vincent.sanders@collabora.co.uk>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2012-06-29 18:45, Vincent Sanders wrote:

>AF_BUS sockets add a netfilter NF_HOOK() on the packet sending path.
>This allows packet to be mangled by registered netfilter hooks.

If you do touch netfiler, consider adding that mailing list as well.

>diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
>index c613cf0..0698924 100644
>--- a/include/linux/netfilter.h
>+++ b/include/linux/netfilter.h
>@@ -67,6 +67,7 @@ enum {
> 	NFPROTO_BRIDGE =  7,
> 	NFPROTO_IPV6   = 10,
> 	NFPROTO_DECNET = 12,
>+	NFPROTO_BUS,
> 	NFPROTO_NUMPROTO,
> };

Make use of the holes that were left.
