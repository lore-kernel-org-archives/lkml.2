Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0FXVfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:35:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44002
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab0FXVfU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:35:20 -0400
Date: Thu, 24 Jun 2010 14:35:32 -0700 (PDT)
Message-Id: <20100624.143532.245414414.davem@davemloft.net>
To: timo.teras@iki.fi
Cc: netdev@vger.kernel.org, justinmattock@gmail.com, eric.dumazet@gmail.com,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm: check bundle policy existance before
 dereferencing it
From: David Miller <davem@davemloft.net>
In-Reply-To: <1277358319-9868-1-git-send-email-timo.teras@iki.fi>
References: <4C22805A.3080307@gmail.com>
	<1277358319-9868-1-git-send-email-timo.teras@iki.fi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Teräs <timo.teras@iki.fi>
Date: Thu, 24 Jun 2010 08:45:19 +0300

> Fix the bundle validation code to not assume having a valid policy.
> When we have multiple transformations for a xfrm policy, the bundle
> instance will be a chain of bundles with only the first one having
> the policy reference. When policy_genid is bumped it will expire the
> first bundle in the chain which is equivalent of expiring the whole
> chain.
> 
> Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: Timo Teräs <timo.teras@iki.fi>

Applied.
