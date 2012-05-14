Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2ENVWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:22:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2ENVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:21:59 -0400
Date: Mon, 14 May 2012 17:20:54 -0400 (EDT)
Message-Id: <20120514.172054.1808957948842230657.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: levinsasha928@gmail.com, edumazet@google.com, dave.taht@bufferbloat.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: codel: fix build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337029683.8512.626.camel@edumazet-glaptop>
References: <1337015687-17693-1-git-send-email-levinsasha928@gmail.com>
	<1337029683.8512.626.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 14:20:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 May 2012 23:08:03 +0200

> Anonymous unions are fine, we use them a lot in kernel.
> 
> Please fix the initializers instead in fq_codel_dump_stats(), because
> these two #define are not very nice.

Agreed.
