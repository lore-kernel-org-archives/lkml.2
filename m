Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0I1ReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:34:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55529
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab0I1ReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:34:18 -0400
Date: Tue, 28 Sep 2010 10:34:38 -0700 (PDT)
Message-Id: <20100928.103438.193722403.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, masa-korg@dsn.okisemi.com
Subject: Re: [PATCH -next] pch_gbe: add header files
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100928095643.18c5020f.randy.dunlap@oracle.com>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
	<20100928095643.18c5020f.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 28 Sep 2010 09:56:43 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors, more header files needed.
> 
> drivers/net/pch_gbe/pch_gbe_main.c:965: error: implicit declaration of function 'tcp_hdr'
> drivers/net/pch_gbe/pch_gbe_main.c:965: error: invalid type argument of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:968: error: invalid type argument of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:976: error: implicit declaration of function 'udp_hdr'
> drivers/net/pch_gbe/pch_gbe_main.c:976: error: invalid type argument of '->' (have 'int')
> drivers/net/pch_gbe/pch_gbe_main.c:980: error: invalid type argument of '->' (have 'int')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
