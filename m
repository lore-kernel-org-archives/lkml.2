Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2LPRRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:17:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40734 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2LPRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:17:49 -0500
Date: Sun, 16 Dec 2012 09:17:47 -0800 (PST)
Message-Id: <20121216.091747.271269648244929827.davem@davemloft.net>
To: simon@fire.lp0.eu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, vyasevic@redhat.com
Subject: Re: [PATCH] ipv6: Fix Makefile offload objects
From: David Miller <davem@davemloft.net>
In-Reply-To: <50CDFB36.1020604@simon.arlott.org.uk>
References: <50CDFB36.1020604@simon.arlott.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>
Date: Sun, 16 Dec 2012 16:47:50 +0000

> The following commit breaks IPv6 TCP transmission for me:
> 	Commit 75fe83c32248d99e6d5fe64155e519b78bb90481
> 	Author: Vlad Yasevich <vyasevic@redhat.com>
> 	Date:   Fri Nov 16 09:41:21 2012 +0000
> 	ipv6: Preserve ipv6 functionality needed by NET
> 
> This patch fixes the typo "ipv6_offload" which should be
> "ipv6-offload".
> 
> I don't know why not including the offload modules should
> break TCP. Disabling all offload options on the NIC didn't
> help. Outgoing pulseaudio traffic kept stalling.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Applied, since the fix is so obvious.

I'll let Vlad explain why it has such an unexpected
effect.

Thanks.
