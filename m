Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0GUVnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:43:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53042
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186Ab0GUVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:43:17 -0400
Date: Wed, 21 Jul 2010 14:43:33 -0700 (PDT)
Message-Id: <20100721.144333.82796756.davem@davemloft.net>
To: joe@perches.com
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net/qlge: Remove duplicated initial
 DUMP_ macro entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279747141.1909.22.camel@Joe-Laptop.home>
References: <1279576149.5434.59.camel@Joe-Laptop.home>
	<20100721.135800.43444396.davem@davemloft.net>
	<1279747141.1909.22.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 21 Jul 2010 14:19:01 -0700

> There are a couple of errors in the previous patch.
> Two of the first DUMP_<foo> entries are duplicated.
> Sorry, bad use of emacs macros...
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Since I didn't push your original change out yet, I'll just add this
to the original commit.

Thanks!
