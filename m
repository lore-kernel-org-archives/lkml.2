Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab1ESTbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:31:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab1ESTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:31:01 -0400
Date: Thu, 19 May 2011 15:27:03 -0400 (EDT)
Message-Id: <20110519.152703.1327182804872376183.davem@davemloft.net>
To: tsunanet@gmail.com
Cc: alexander.zimmermann@comsys.rwth-aachen.de, hagen@jauu.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft
 RFC 2988bis-02.
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikZasOVfr2zTfXVjPqQsnzy9Hk5uA@mail.gmail.com>
References: <BANLkTimSZEbnNVzi3UvBFndHp25S0ow7YQ@mail.gmail.com>
	<1456193D-84D1-46E2-B930-8FD0A5B8C409@comsys.rwth-aachen.de>
	<BANLkTikZasOVfr2zTfXVjPqQsnzy9Hk5uA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 May 2011 12:27:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tsuna <tsunanet@gmail.com>
Date: Thu, 19 May 2011 10:11:50 -0700

> Looking through the kernel, I see that SCTP already has knobs for
> this: sctp_rto_initial, sctp_rto_min, sctp_rto_max.  You can even
> control the constants used to update rttvar and srtt: sctp_rto_alpha,
> sctp_rto_beta

SCTP is 1) not even a sliver of deployment compared to TCP and 2)
doesn't get nearly the same scrutiny on patch review that TCP
changes do.

I basically let the SCTP folks play in their own sandbox, because
frankly SCTP doesn't matter.

The only time I care about an SCTP change is when it has an impact on
the rest of the networking code.

So using SCTP as an example of "see we do this already over here" is a
non-starter.  Don't do it.
