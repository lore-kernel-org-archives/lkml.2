Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2DCCYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:24:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57297 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2DCCYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:24:08 -0400
Date: Mon, 02 Apr 2012 22:23:00 -0400 (EDT)
Message-Id: <20120402.222300.1137842205135530387.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: remi@remlab.net, levinsasha928@gmail.com, remi.denis-courmont@nokia.com,
        davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333419304.18626.5.camel@edumazet-glaptop>
References: <1333417997.18626.1.camel@edumazet-glaptop>
	<20120402.215911.1929019308299701014.davem@davemloft.net>
	<1333419304.18626.5.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 02 Apr 2012 19:23:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 03 Apr 2012 04:15:04 +0200

> Any idea of a representative benchmark in dgram af_unix ?

Maybe you could try to make bw_unix from lmbench use
SOCK_DGRAM? :-)

