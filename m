Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0GaGFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:05:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45303
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab0GaGFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:05:07 -0400
Date: Fri, 30 Jul 2010 23:05:24 -0700 (PDT)
Message-Id: <20100730.230524.39186905.davem@davemloft.net>
To: dp@highloadlab.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, kaber@trash.net,
        pekkas@netcore.fi, yoshfuji@linux-ipv6.org, eric.dumazet@gmail.com,
        ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
        steve@digidescorp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, william.allen.simpson@gmail.com
Subject: Re: [PATCH] tcp: cookie transactions setsockopt memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinHWJviHmhVcFQkobsgxa4-AaFUpHmd1wybiB+u@mail.gmail.com>
References: <AANLkTinHWJviHmhVcFQkobsgxa4-AaFUpHmd1wybiB+u@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <dp@highloadlab.com>
Date: Thu, 29 Jul 2010 15:59:36 +0400

> From: Dmitry Popov <dp@highloadlab.com>
> 
> There is a bug in do_tcp_setsockopt(net/ipv4/tcp.c),
> TCP_COOKIE_TRANSACTIONS case.
> In some cases (when tp->cookie_values == NULL) new tcp_cookie_values
> structure can be allocated (at cvp), but not bound to
> tp->cookie_values. So a memory leak occurs.
> 
> Signed-off-by: Dmitry Popov <dp@highloadlab.com>

Applied and queued up for -stable, thanks Dmitry.
