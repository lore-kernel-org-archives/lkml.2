Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2D3Rnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:43:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41016 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab2D3Rnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:43:50 -0400
Date: Mon, 30 Apr 2012 13:41:40 -0400 (EDT)
Message-Id: <20120430.134140.1738751315208907289.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: kaffeemonster@googlemail.com, eric.dumazet@gmail.com, matt@ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335763568.20866.37.camel@pasglop>
References: <1335760199.20866.33.camel@pasglop>
	<4F9E188E.80503@googlemail.com>
	<1335763568.20866.37.camel@pasglop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 10:41:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 30 Apr 2012 15:26:08 +1000

> David, what's the right way to fix that ?

There is no doubt that sock_fprog is the correct datastructure to use.
