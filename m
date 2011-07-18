Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1GRTrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:47:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58027 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1GRTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:47:48 -0400
Date: Mon, 18 Jul 2011 12:46:38 -0700 (PDT)
Message-Id: <20110718.124638.30010338187296272.davem@davemloft.net>
To: rweikusat@mobileactivedefense.com
Cc: adobriyan@gmail.com, kaber@trash.net, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 12:46:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Date: Mon, 18 Jul 2011 20:43:30 +0100

> [rw@sapphire]~/work/linux-2-6/net/netfilter $find -name '*.c' | xargs grep '^#ifdef' | wc -l
> 239
> [rw@sapphire]~/work/linux-2-6/net/netfilter $..
> [rw@sapphire]~/work/linux-2-6/net $find -name '*.c' | xargs grep '^#ifdef' | wc -l
> 1672

You've shown nothing.  Showing exceptions does not prove that the
general effort has been to keep ifdef crap out of *.c files.

And every developer or maintainer who says no to ifdefs in *.c files
for new changes is %100 right.

We're also specifically talking about namespace stuff, so you should have
at least refined your match criteria just a little bit.
