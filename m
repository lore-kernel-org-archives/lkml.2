Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1HOViO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:38:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1HOViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:38:12 -0400
Date: Mon, 15 Aug 2011 14:37:03 -0700 (PDT)
Message-Id: <20110815.143703.755340393661399080.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: remove unnecessary macros from spinlock_64.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20041.32055.652850.148995@pilspetsen.it.uu.se>
References: <20041.32055.652850.148995@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 15 Aug 2011 14:37:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Mon, 15 Aug 2011 22:10:31 +0200

> The sparc64 spinlock_64.h contains a number of operations defined
> first as static inline functions, and then as macros with the same
> names and parameters as the functions.  Maybe this was needed at
> some point in the past, but now nothing seems to depend on these
> macros (checked with a recursive grep looking for ifdefs on these
> names).  Other archs don't define these identity-macros.
> 
> So this patch deletes these unnecessary macros.
> 
> Compile-tested with sparc64_defconfig.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Applied.
