Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1EWBCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:02:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1EWBCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:02:07 -0400
Date: Sun, 22 May 2011 21:01:59 -0400 (EDT)
Message-Id: <20110522.210159.2028885878337277330.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] net: filter: move forward declarations to avoid
 compile warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110522170811.GA2758@osiris.boeblingen.de.ibm.com>
References: <20110522170811.GA2758@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 May 2011 18:02:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sun, 22 May 2011 19:08:11 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Get rid of this compile warning:
> 
> In file included from arch/s390/kernel/compat_linux.c:37:0:
> include/linux/filter.h:139:23: warning: 'struct sk_buff' declared inside parameter list
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied.
