Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0D1Rvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:51:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45828
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab0D1Rvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:51:48 -0400
Date: Wed, 28 Apr 2010 10:51:54 -0700 (PDT)
Message-Id: <20100428.105154.267381426.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: grzegorz.chwesewicz@retis.net.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, zbr@ioremap.net
Subject: Re: Problem with "tcp: bind() fix when many ports are bound" commit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272476697.2267.95.camel@edumazet-laptop>
References: <20100428.095032.32709294.davem@davemloft.net>
	<1272476040.2267.87.camel@edumazet-laptop>
	<1272476697.2267.95.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 28 Apr 2010 19:44:57 +0200

> David, I think we should revert patches for linux-2.6, and work on this
> problem more closely on net-next-2.6

Yep, I agree, I'll send the revert to Linus.

Thanks.
