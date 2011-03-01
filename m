Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1CAXPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:15:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59546
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148Ab1CAXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:15:11 -0500
Date: Tue, 01 Mar 2011 15:15:48 -0800 (PST)
Message-Id: <20110301.151548.116374357.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] ipx: remove the BKL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299021191-17961-8-git-send-email-arnd@arndb.de>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
	<1299021191-17961-8-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed,  2 Mar 2011 00:13:11 +0100

> This replaces all instances of lock_kernel in the
> IPX code with lock_sock. As far as I can tell, this
> is safe to do, because there is no global state
> that needs to be locked in IPX, and the code does
> not recursively take the lock or sleep indefinitely
> while holding it.
> 
> Compile-tested only.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: David S. Miller <davem@davemloft.net>
