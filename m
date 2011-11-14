Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1KNXmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:42:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48948 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1KNXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:42:48 -0500
Date: Mon, 14 Nov 2011 18:42:40 -0500 (EST)
Message-Id: <20111114.184240.1832866874941847383.davem@davemloft.net>
To: grundler@chromium.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Subject: Re: [PATCH 5/5] net-next:asix: update VERSION and white space
 changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321312921-7748-5-git-send-email-grundler@chromium.org>
References: <1321312921-7748-1-git-send-email-grundler@chromium.org>
	<1321312921-7748-5-git-send-email-grundler@chromium.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 Nov 2011 15:42:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>
Date: Mon, 14 Nov 2011 15:22:01 -0800

> No functional changes. Three things targeted:
> o update VERSION to reflect previous changes.
> o fix up white space/formatting of some lines
> o define 150 to be AX_SWRESET_MDELAY (self documenting code)
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Why have such a wonderful set of real bug fixes that I can apply right
now and send off to Linus's tree, only to sabotage it with whitespace
changes at the end which are no appropriate?

Please, just submit this without the whitespace and other cleanup
stuff.  Restrict it to real bug fixes, and I'll push it around.

The whitespace and other bits can be submitted for net-next afterwards.
