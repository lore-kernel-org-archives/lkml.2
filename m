Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2K1Qfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:35:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50215 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2K1Qfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:35:32 -0500
Date: Wed, 28 Nov 2012 11:35:30 -0500 (EST)
Message-Id: <20121128.113530.1758331048704686053.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.weinberger@gmail.com
Subject: Re: [PATCH 1/2] ewrk3: silence GCC warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354009637.1420.50.camel@x61.thuisdomein>
References: <1354009637.1420.50.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 27 Nov 2012 10:47:17 +0100

> Building ewrk3.o triggers this GCC warning:
>     drivers/net/ethernet/dec/ewrk3.c: In function '__check_irq':
>     drivers/net/ethernet/dec/ewrk3.c:1915:1: warning: return from incompatible pointer type [enabled by default]
> 
> This can be trivially fixed by changing the 'irq' parameter from int to
> byte (which is an alias for unsigned char for module parameters).
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
