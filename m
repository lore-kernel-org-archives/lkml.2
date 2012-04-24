Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2DXDaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:30:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34920 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2DXDaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:30:16 -0400
Date: Mon, 23 Apr 2012 23:30:09 -0400 (EDT)
Message-Id: <20120423.233009.1036274421495158511.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 20:30:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Mon, 23 Apr 2012 20:18:29 -0700

> Make get_current() into a static inline function in the
> generic version of current.h so we match what almost every
> architecture is doing. This allows us to move most of the arches
> over to this generic header instead of redefining the same thing
> over and over in each asm directory.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arch@vger.kernel.org

For sparc bits:

Acked-by: David S. Miller <davem@davemloft.net>
