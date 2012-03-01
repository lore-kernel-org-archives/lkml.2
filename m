Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2CAUnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:43:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab2CAUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:43:08 -0500
Date: Thu, 01 Mar 2012 15:42:58 -0500 (EST)
Message-Id: <20120301.154258.1696335721519362903.davem@davemloft.net>
To: javier.martinez@collabora.co.uk
Cc: rodrigo.moya@collabora.co.uk, javier@collabora.co.uk,
        eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F4F641E.7000501@collabora.co.uk>
References: <1330426059.2139.21.camel@megeve>
	<20120228.140558.1132853996225815681.davem@davemloft.net>
	<4F4F641E.7000501@collabora.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Mar 2012 12:43:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Thu, 01 Mar 2012 12:57:18 +0100

> Does this makes more sense to you?

No, creating an entire new socket family for one user doesn't make
any sense.
