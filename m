Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2HVE0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:26:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48467 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2HVE0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:26:40 -0400
Date: Tue, 21 Aug 2012 21:26:39 -0700 (PDT)
Message-Id: <20120821.212639.516363749620870558.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: eric.dumazet@gmail.com, ncardwell@google.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: David Miller <davem@davemloft.net>
In-Reply-To: <50345B12.1050600@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 21 Aug 2012 23:07:46 -0500

> I find it hard to understand why this patch should cause these
> effects; however, I have verified that a kernel generated from "git
> checkout e86b2919" works fine. This commit is immediately before the
> patch in question.

I can guarentee it's improper skb->truesize setting in these drivers,
or use of too huge buffer sizes compared to the amount of data
contained within the packet.
