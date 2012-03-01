Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966159Ab2CAM0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:26:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab2CAM0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:26:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.180.24.166 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330604802.2465.43.camel@edumazet-laptop>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: David Miller <davem@davemloft.net>, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Mar 2012 04:26:42 -0800
In-Reply-To: <4F4F641E.7000501@collabora.co.uk>
References: <4F4B8C66.5060206@collabora.co.uk>
	 <20120227.140535.1623396420455657443.davem@davemloft.net>
	 <1330426059.2139.21.camel@megeve>
	 <20120228.140558.1132853996225815681.davem@davemloft.net>
	 <4F4F641E.7000501@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 mars 2012 à 12:57 +0100, Javier Martinez Canillas a écrit :

> Yes, you are right it doesn't follow AF_UNIX semantics so Unix sockets
> is not the best place to add our multicast implementation.
> 

Right, AF_UNIX is already a nightmare to maintain.

> So, now we are trying a different approach. To create a new address
> family AF_MCAST. That way we can have more control over the semantics of
> the socket interface for that family.
> 
> We expect to have some patches in a few days and we will resend.
> 
> Does this makes more sense to you?
> 

Why adding an obscure set of IPC mechanism in network tree, and not
using (maybe extending) traditional IPC (Messages queues, semaphores,
Shared memory, pipes, futexes, ...).



