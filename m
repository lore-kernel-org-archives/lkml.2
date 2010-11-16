Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0KPSWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:22:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56905
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0KPSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:22:49 -0500
Date: Tue, 16 Nov 2010 10:23:14 -0800 (PST)
Message-Id: <20101116.102314.260073530.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 2/9] drivers/isdn/mISDN: Use printf extension %pV
From: David Miller <davem@davemloft.net>
In-Reply-To: <b7079ecc43454c8b8baaef07f8cf1c1756c2ce3e.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
	<b7079ecc43454c8b8baaef07f8cf1c1756c2ce3e.1289348757.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue,  9 Nov 2010 16:35:16 -0800

> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
