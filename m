Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2BXUgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:36:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab2BXUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:36:41 -0500
Date: Fri, 24 Feb 2012 15:36:16 -0500 (EST)
Message-Id: <20120224.153616.117399887784547022.davem@davemloft.net>
To: javier@collabora.co.uk
Cc: eric.dumazet@gmail.com, lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        rodrigo.moya@collabora.co.uk, sjoerd.simons@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Feb 2012 12:36:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My first impression is that I'm amazed at how much complicated new
code you have to add to support groups of receivers of AF_UNIX
messages.

I can't see how this is better than doing multicast over ipv4 using
UDP or something like that, code which we have already and has been
tested for decades.

I really don't want to apply this stuff, it looks bloated,
complicated, and there is another avenue for doing what you want to
do.

Applications have to change to support the new multicast facilities,
so they can equally be changed to use a real transport that already
supports multicasting.
