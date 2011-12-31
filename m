Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1LaWs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 17:48:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51219 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1LaWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 17:48:56 -0500
Date: Sat, 31 Dec 2011 17:46:05 -0500 (EST)
Message-Id: <20111231.174605.901317517736513953.davem@davemloft.net>
To: joshhunt00@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] IPv6: Avoid taking write lock for
 /proc/net/ipv6_route
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAKA=qzb=PYTMO=9KFpTJ9BVdDRkqbaCuW02pbW0onM8gU1E7sw@mail.gmail.com>
References: <CAKA=qzbZ4x5u1bBM0gAECeMNutyaVzp1FmRPwKHsBEEs7984ag@mail.gmail.com>
	<20111230.170905.1348056803377924696.davem@davemloft.net>
	<CAKA=qzb=PYTMO=9KFpTJ9BVdDRkqbaCuW02pbW0onM8gU1E7sw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 31 Dec 2011 14:46:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Hunt <joshhunt00@gmail.com>
Date: Sat, 31 Dec 2011 13:49:38 -0600

> Thanks David. Are you aware if anyone has started the work to make
> IPv6 traversals RCU safe?

Nobody is working on this.
