Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1DDFEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 01:04:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55487
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab1DDFEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 01:04:47 -0400
Date: Sun, 03 Apr 2011 22:04:10 -0700 (PDT)
Message-Id: <20110403.220410.123991133.davem@davemloft.net>
To: mk@lab.zgora.pl
Cc: yevgenyp@mellanox.co.il, rolandd@cisco.com, alekseys@voltaire.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4: fix kfree on error path in new_steering_entry()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301865983-6584-1-git-send-email-mk@lab.zgora.pl>
References: <1301865983-6584-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <mk@lab.zgora.pl>
Date: Sun,  3 Apr 2011 23:26:23 +0200

> On error path kfree() should get pointer to memory allocated by
> kmalloc() not the address of variable holding it (which is on stack).
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Applied, thanks.
