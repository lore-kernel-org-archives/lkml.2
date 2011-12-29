Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1L2WGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 17:06:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37247 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1L2WGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 17:06:30 -0500
Date: Thu, 29 Dec 2011 17:05:14 -0500 (EST)
Message-Id: <20111229.170514.1766899380937848638.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: gurligebis@gentoo.org, shemminger@vyatta.com, bhutchings@solarflare.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on
 low-end broads.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111229183902.GC21946@electric-eye.fr.zoreil.com>
References: <CACPM=kXOddA+T6vQPijR6sh8x5cMO=4baKGeKxEmMKG896Lz4g@mail.gmail.com>
	<20111229153902.GB21946@electric-eye.fr.zoreil.com>
	<20111229183902.GC21946@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Dec 2011 14:05:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Thu, 29 Dec 2011 19:39:02 +0100

> Francois Romieu <romieu@fr.zoreil.com> :
> [...]
>> Feel free to try the extra "new year's eve week end is getting closer"
>> patch below (against net-next).
>> 
>> You have been warned.
> 
> The one below could be a bit better.

Obviously you'll need to resolve the use of rp->lock as an IRQ safe lock
in {get,src}_wol() so that this lock is consistently used as a BH safe
lock.  Your "Huh?" comments make it clear you are aware of this TODO. :-)

But other than that this patch looks good to me, just some testing and
debugging are needed.
