Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2GTU3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:29:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55362 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GTU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:29:37 -0400
Date: Fri, 20 Jul 2012 13:29:34 -0700 (PDT)
Message-Id: <20120720.132934.854459589738348753.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nzimmer@sgi.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Robin.Holt@sgi.com
Subject: Re: [RFC] net: further seperate dst_entry.__refcnt from cache
 contention
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342815411.2626.7936.camel@edumazet-glaptop>
References: <1342813587-31601-1-git-send-email-nzimmer@sgi.com>
	<1342815411.2626.7936.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 20 Jul 2012 22:16:51 +0200

> Another idea concerning very hot dst would be to clone them on demand.

The FIB info cached dsts could also be made per-cpu.

And yes, the only reason I'm entertaining that idea now is the fact
that we'll have the number of dsts in the system under control.
