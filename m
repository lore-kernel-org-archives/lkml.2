Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0IQXfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:35:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33335
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab0IQXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:35:11 -0400
Date: Fri, 17 Sep 2010 16:35:30 -0700 (PDT)
Message-Id: <20100917.163530.266095048.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/12] BKL: Remove BKL from capifs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284659185-8942-7-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
	<1284659185-8942-7-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Sep 2010 19:46:19 +0200

> The BKL is only used in fill_super, which is  protected by the superblocks
> s_umount rw_semaphore. Therefore it is safe to remove the BKL entirely.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: netdev@vger.kernel.org

I've searched Linus's tree, net-2.6, and net-next-2.6 and I cannot
find one reference to lock_kernel() in drivers/isdn/capi/capifs.c
in any of them.

What did you write this patch against?
