Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1EVWPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:15:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab1EVWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:15:37 -0400
Date: Sun, 22 May 2011 18:15:30 -0400 (EDT)
Message-Id: <20110522.181530.2048359124881166038.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: add missing prefetch.h include
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110522165510.GB2504@osiris.boeblingen.de.ibm.com>
References: <20110522165510.GB2504@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 May 2011 15:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sun, 22 May 2011 18:55:10 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes build errors on s390 and probably other archs as well:
> 
> In file included from net/ipv4/ip_forward.c:32:0:
> include/net/udp.h: In function 'udp_csum_outgoing':
> include/net/udp.h:141:2: error: implicit declaration of function 'prefetch'
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

No, as Linus pointed out, he will just remove these prefetches
in here, they should just be removed.
