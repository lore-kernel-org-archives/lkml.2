Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1ESFuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:50:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37525 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1ESFuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:50:54 -0400
Date: Thu, 19 May 2011 01:46:56 -0400 (EDT)
Message-Id: <20110519.014656.1735519603194773578.davem@davemloft.net>
To: tsunanet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, hagen@jauu.net,
        eric.dumazet@gmail.com, alexander.zimmermann@comsys.rwth-aachen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft
 RFC 2988bis-02.
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikQEq9+YkJHcTe3PWnRvh7AN=VVWA@mail.gmail.com>
References: <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
	<20110519.001426.2119532755281545481.davem@davemloft.net>
	<BANLkTikQEq9+YkJHcTe3PWnRvh7AN=VVWA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 22:47:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tsuna <tsunanet@gmail.com>
Date: Wed, 18 May 2011 21:33:21 -0700

> On Wed, May 18, 2011 at 9:14 PM, David Miller <davem@davemloft.net> wrote:
>> I really would rather see the initial RTO be static and be set to 1
>> with fallback RTO of 3.
> 
> I can also provide a simple patch for this if you want to start from
> there.  And then maybe we can discuss having a runtime knob some more
> :-)

Yeah why don't we do that :-)
