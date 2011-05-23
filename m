Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab1EWViU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:38:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41682 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab1EWViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:38:18 -0400
Date: Mon, 23 May 2011 17:38:06 -0400 (EDT)
Message-Id: <20110523.173806.1174406351709452162.davem@davemloft.net>
To: joe@perches.com
Cc: greearb@candelatech.com, linux-arch@vger.kernel.org, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add and use WARN_RATELIMIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1305999731.git.joe@perches.com>
References: <1305666832.1722.62.camel@Joe-Laptop>
	<cover.1305999731.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 May 2011 14:38:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 21 May 2011 10:48:38 -0700

> Generic mechanism to ratelimit WARN uses.
> 
> Joe Perches (2):
>   bug.h: Add WARN_RATELIMIT
>   net: filter: Use WARN_RATELIMIT
> 
>  include/asm-generic/bug.h |   16 ++++++++++++++++
>  net/core/filter.c         |    4 +++-
>  2 files changed, 19 insertions(+), 1 deletions(-)

This looks fine to me, and no objections have been voiced otherwise,
so applied to net-2.6, thanks!
