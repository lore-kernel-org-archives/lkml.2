Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1LUIHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:07:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48074 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1LUIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:07:34 -0500
Date: Wed, 21 Dec 2011 03:07:27 -0500 (EST)
Message-Id: <20111221.030727.1528369698756365464.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: richard.weinberger@gmail.com, gladewitz@gmx.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel-DOS error in arp mechanism
 =?iso-2022-jp-3?B?GyQoUSN8GyhC?= no delete off incomplete arp adresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324453467.2610.20.camel@edumazet-laptop>
References: <4EEC5286.3070408@gmx.de>
	<CAFLxGvxjLCyMCPXtpm7a7RaOL4A4=bhCLPKD=FVAc8xOdx_CsQ@mail.gmail.com>
	<1324453467.2610.20.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 00:07:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 21 Dec 2011 08:44:27 +0100

> David, I suggest we add back the garbage collector for current kernels,
> we'll remove it when route cache really disappear ?
> 
> I'll send a patch today.

Yes, it's the best idea.

We can actually remove it again as early as when when route neigh's
are ref-less.
