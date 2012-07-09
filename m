Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2GJADz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:03:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2GJADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:03:19 -0400
Date: Mon, 09 Jul 2012 16:49:23 -0700 (PDT)
Message-Id: <20120709.164923.898772652506167140.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: herton.krzesinski@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        edumazet@google.com
Subject: Re: [ 35/48] dummy: fix rcu_sched self-detected stalls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341877626.25597.300.camel@deadeye.wl.decadent.org.uk>
References: <20120709143121.743971024@decadent.org.uk>
	<20120709233901.GB3237@herton-Z68MA-D2H-B3>
	<1341877626.25597.300.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 10 Jul 2012 00:47:06 +0100

> I built on x86_64...

As did I :-)

> But it's not an important bug in mainline (yet) so perhaps we can treat
> it as only required in stable.

I think this is the best thing to do for now.
