Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0JROXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:23:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43908
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845Ab0JROXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:23:36 -0400
Date: Mon, 18 Oct 2010 07:23:59 -0700 (PDT)
Message-Id: <20101018.072359.104044884.davem@davemloft.net>
To: awalls@md.metrocast.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, kaber@trash.net
Subject: Re: [PATCH] IPv4: route.c: Change checks against 0xffffffff to
 ipv4_is_lbcast()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1287364282.2320.20.camel@morgan.silverblock.net>
References: <1287364282.2320.20.camel@morgan.silverblock.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 17 Oct 2010 21:11:22 -0400

> 
> Change a few checks against the hardcoded broadcast address,
> 0xffffffff, to ipv4_is_lbcast().  Remove some existing checks
> using ipv4_is_lbcast() that are now obviously superfluous.
> 
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Applied.
