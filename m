Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2B1TGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:06:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965674Ab2B1TGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:06:13 -0500
Date: Tue, 28 Feb 2012 14:05:58 -0500 (EST)
Message-Id: <20120228.140558.1132853996225815681.davem@davemloft.net>
To: rodrigo.moya@collabora.co.uk
Cc: javier.martinez@collabora.co.uk, javier@collabora.co.uk,
        eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330426059.2139.21.camel@megeve>
References: <4F4B8C66.5060206@collabora.co.uk>
	<20120227.140535.1623396420455657443.davem@davemloft.net>
	<1330426059.2139.21.camel@megeve>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 11:06:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodrigo Moya <rodrigo.moya@collabora.co.uk>
Date: Tue, 28 Feb 2012 11:47:39 +0100

> Because of all of this, UDP/IP multicast wasn't even considered as an
> option. We might be wrong in some/all of those, so could you please
> comment on them to check if that's so?

You guys seem to want something that isn't AF_UNIX, ordering guarentees
and whatnot, it really has no place in these protocols.

You've designed a userlevel subsystem with requirements that no existing
socket layer can give, and you just figured you'd work that out later.

I think you rather should have reconsidered these premises and designed
something that could handle reality which is AF_UNIX can't do multicast
and nobody guarentees those strange ordering requirements you seem to
have.
