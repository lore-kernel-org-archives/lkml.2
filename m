Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0EJQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:12:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35892
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab0EJQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:12:52 -0400
Date: Mon, 10 May 2010 09:12:57 -0700 (PDT)
Message-Id: <20100510.091257.51273494.davem@davemloft.net>
To: kaber@trash.net
Cc: eric.dumazet@gmail.com, Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BE8290A.2080707@trash.net>
References: <1272865436.2173.182.camel@edumazet-laptop>
	<20100502.225509.233880079.davem@davemloft.net>
	<4BE8290A.2080707@trash.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 10 May 2010 17:40:58 +0200

> I queued this patch in nf-next, the only reason why I haven't
> submitted it yet is that I was unable to get git to cleanly export
> only the proper set of patches meant for -next due to a few merges,
> it insists on including 5 patches already merged upstream. If you
> don't mind ignoring the first 5 patches in the series, I'll send a
> pull request tonight.

Something like "git format-patch origin" doesn't avoid those upstream
commits?  Weird...

Another trick is to specify a commit range using triple-dot "..."
notation, such as "origin...master"
