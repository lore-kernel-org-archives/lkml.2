Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0H3BI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:08:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55570 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0H3BIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:08:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] tcp: select(writefds) don't hang up when a peer close connection
Cc: kosaki.motohiro@jp.fujitsu.com, bhutchings@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org
In-Reply-To: <20100826.122104.115920380.davem@davemloft.net>
References: <1282824448.2263.3.camel@achroite.uk.solarflarecom.com> <20100826.122104.115920380.davem@davemloft.net>
Message-Id: <20100830085152.5237.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Aug 2010 10:08:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Thu, 26 Aug 2010 13:07:28 +0100
> 
> > By the way, I was able to reproduce this bug in RHEL 3 (kernel based on
> > 2.4.21) so it seems to have been around for a while.
> 
> It's existed since September 1998:
> 
> commit 6275af56642b5b9ed9ef15bf5d9718661c5fe79d
> Author: freitag <freitag>
> Date:   Sat Sep 26 06:20:25 1998 +0000
> 
>     Some small fixes.
>     
>     - Remove second check for sk->err in poll as discussed with Linus.
>     - Don't signal writability when the local end has been shut down.
>     - Comment fixes.

because (almostly) nobody were using this feature? ;)



