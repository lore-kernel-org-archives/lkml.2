Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0FBMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:16:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52585
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0FBMQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:16:57 -0400
Date: Wed, 02 Jun 2010 05:17:07 -0700 (PDT)
Message-Id: <20100602.051707.170100284.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH 1/2] mac8390: propagate error code from request_irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.1006011738330.299@localhost>
References: <alpine.OSX.2.00.1005312244520.1490@localhost>
	<20100531.060225.68146363.davem@davemloft.net>
	<alpine.OSX.2.00.1006011738330.299@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Tue, 1 Jun 2010 22:18:32 +1000 (EST)

> 
> Use the request_irq() error code as the return value for mac8390_open(). 
> EAGAIN doesn't make sense for Nubus slot IRQs. Only this driver can claim 
> this IRQ (until the NIC is removed, which means everything is powered 
> down).
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Applied.
