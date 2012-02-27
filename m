Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2B0TFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:05:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2B0TFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:05:46 -0500
Date: Mon, 27 Feb 2012 14:05:35 -0500 (EST)
Message-Id: <20120227.140535.1623396420455657443.davem@davemloft.net>
To: javier.martinez@collabora.co.uk
Cc: javier@collabora.co.uk, eric.dumazet@gmail.com, lennart@poettering.net,
        kay.sievers@vrfy.org, alban.crequy@collabora.co.uk,
        bart.cerneels@collabora.co.uk, rodrigo.moya@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F4B8C66.5060206@collabora.co.uk>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
	<20120224.153616.117399887784547022.davem@davemloft.net>
	<4F4B8C66.5060206@collabora.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Feb 2012 11:05:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Mon, 27 Feb 2012 15:00:06 +0100

> Primary for performance reasons. D-bus is an IPC system for processes in
> the same machine so traversing the whole TCP/IP stack seems a little
> overkill to me.

You haven't actually tested what the cost of this actually is, so what
you're saying is mere speculation.  In many cases TCP/UDP over
loopback is actually faster than AF_UNIX.

Since this is the premise of your whole rebuttal, I'll simply stop
reading here.
