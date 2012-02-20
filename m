Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2BTOMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:12:50 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46383 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2BTOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:12:48 -0500
Date: Mon, 20 Feb 2012 09:12:36 -0500 (EST)
Message-Id: <20120220.091236.727270400763031992.davem@davemloft.net>
To: javier.martinez@collabora.co.uk
Cc: eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        rodrigo.moya@collabora.co.uk, sjoerd.simons@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFCv3] 0/14 af_unix: Multicast and filtering features on
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F4211B5.2050602@collabora.co.uk>
References: <4F35206D.8010604@collabora.co.uk>
	<4F4211B5.2050602@collabora.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Feb 2012 06:12:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Mon, 20 Feb 2012 10:26:13 +0100

> We didn't want to send the full patches since we are more interested to
> discuss the proposed architecture and ABI rather than the kernel
> implementation (which can always be rework to meet upstream code quality).

Big mistake.
