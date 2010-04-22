Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0DVFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:25:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51727
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab0DVFZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:25:57 -0400
Date: Wed, 21 Apr 2010 22:26:02 -0700 (PDT)
Message-Id: <20100421.222602.211557559.davem@davemloft.net>
To: ppergame@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: change recvform to return same address length as
 getsockname on unnamed unix sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <v2x7447a0ac1004212029qd1866eaekc769fee5b13ac09d@mail.gmail.com>
References: <v2x7447a0ac1004212029qd1866eaekc769fee5b13ac09d@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Pergamenshchik <ppergame@gmail.com>
Date: Wed, 21 Apr 2010 20:29:25 -0700

> unix_*_recvmsg() returns zero-length sockaddr if the sender is an
> unnamed AF_UNIX socket. Change it to return a two-byte sockaddr with
> just the address family, to be consistent with unix_getname().
> 
> Signed-off-by: Pavel Pergamenshchik <ppergame@gmail.com>

Since we've behaved this way for at least 10 years, the existing
behavior is the user visible ABI and the risk of breaking things by
making the change is too great.

I'm not applying this, sorry.
