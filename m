Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1GRUUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:20:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49274 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GRUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:20:52 -0400
Date: Mon, 18 Jul 2011 13:19:43 -0700 (PDT)
Message-Id: <20110718.131943.1892150276130348431.davem@davemloft.net>
To: rweikusat@mobileactivedefense.com
Cc: adobriyan@gmail.com, kaber@trash.net, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
References: <87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 13:19:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Date: Mon, 18 Jul 2011 21:17:00 +0100

> David Miller <davem@davemloft.net> writes:
>> We're also specifically talking about namespace stuff, so you should have
>> at least refined your match criteria just a little bit.
> 
> The person I was replying to wrote 'We did whole networking without
> sprinkling ifdefs'.

He was talking specifically about namespace stuff.
