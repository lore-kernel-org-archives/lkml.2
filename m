Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1LFSTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:19:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1LFSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:19:40 -0500
Date: Tue, 06 Dec 2011 13:17:10 -0500 (EST)
Message-Id: <20111206.131710.2181211652306186928.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1323163127.git.LW@KARO-electronics.de>
References: <cover.1323163127.git.LW@KARO-electronics.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Dec 2011 10:17:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please use a more reasonable Subject line for your patches.

Saying "several cleanups and bugfixes for fec.c:" in every subject
line of a whole series of patches isn't very helpful.

Just "fec: set con_id in clk_get() call to NULL", as one example, would be fine.

You will need to resubmit this entire patch series, afresh, with this fixup.
Do not try to fix it up by replying to the individual patch postings.
