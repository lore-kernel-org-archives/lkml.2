Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1BIUnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:43:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43953
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1BIUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:43:18 -0500
Date: Wed, 09 Feb 2011 12:43:53 -0800 (PST)
Message-Id: <20110209.124353.104047600.davem@davemloft.net>
To: randy.dunlap@Oracle.COM
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH -next] can: softing_cs needs slab.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209084456.802370fa.randy.dunlap@oracle.com>
References: <20110209170225.94eae681.sfr@canb.auug.org.au>
	<20110209084456.802370fa.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@Oracle.COM>
Date: Wed, 9 Feb 2011 08:44:56 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> softing_cs.c uses kzalloc & kfree, so it needs to include linux/slab.h.
> 
> drivers/net/can/softing/softing_cs.c:234: error: implicit declaration of function 'kfree'
> drivers/net/can/softing/softing_cs.c:271: error: implicit declaration of function 'kzalloc'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
