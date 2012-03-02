Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2CBJk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:40:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52469 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2CBJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:40:22 -0500
Date: Fri, 02 Mar 2012 04:39:27 -0500 (EST)
Message-Id: <20120302.043927.1075141476785695419.davem@davemloft.net>
To: javier.martinez@collabora.co.uk
Cc: shemminger@vyatta.com, ying.xue@windriver.com, luiz.dentz@gmail.com,
        eric.dumazet@gmail.com, rodrigo.moya@collabora.co.uk,
        javier@collabora.co.uk, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F509274.9060302@collabora.co.uk>
References: <CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
	<20120302.035509.1994457175982020283.davem@davemloft.net>
	<4F509274.9060302@collabora.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 02 Mar 2012 01:39:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Fri, 02 Mar 2012 10:27:16 +0100

> Do you think that a simpler AF_UNIX multicast implementation without the
> locking to guarantee order delivery and the flow control that blocks the
> sender can be resend to you to reconsider merging it?

No.
