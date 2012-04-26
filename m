Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2DZJW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:22:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2DZJW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:22:27 -0400
Date: Thu, 26 Apr 2012 05:20:06 -0400 (EDT)
Message-Id: <20120426.052006.1832921763623188173.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, avictor.za@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [GIT PULL] net/at91: at91_ether fixes for 3.4-rc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F991210.8060409@atmel.com>
References: <4F991210.8060409@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Apr 2012 02:20:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 26 Apr 2012 11:14:56 +0200

> Can you please pull those fixes for 3.4-rc? The ARM/AT91 part
> of modifications is pretty small and bounded to a single SoC so
> it will not mess with arm-soc git tree.

Please post the patches themselves to netdev.

You can give me pull requests, but those go into the "[PATCH 0/N] ..."
email, it doesn't preclude you're still having to post the actual
patches.

Otherwise nobody can review your work.
