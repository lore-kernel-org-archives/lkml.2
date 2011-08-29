Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab1H2Gff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:35:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54226 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1H2Gfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:35:31 -0400
Date: Mon, 29 Aug 2011 02:34:08 -0400 (EDT)
Message-Id: <20110829.023408.440980195220010292.davem@davemloft.net>
To: stephen.hemminger@vyatta.com
Cc: eric.dumazet@gmail.com, herbert@gondor.hengli.com.au, kaber@trash.net,
        mirq-linux@rere.qmqm.pl, therbert@google.com, jesse@nicira.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, mitsuo.hayasaka.hu@hitachi.com
Subject: Re: [PATCH net-next ] Fix time-lag of IFF_RUNNING flag consistency
 between vlan and real devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <f6ded72b-346d-43af-af47-4edae5060406@tahiti.vyatta.com>
References: <1314540589.3036.12.camel@edumazet-laptop>
	<f6ded72b-346d-43af-af47-4edae5060406@tahiti.vyatta.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 28 Aug 2011 23:34:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen.hemminger@vyatta.com>
Date: Sun, 28 Aug 2011 23:06:28 -0700 (PDT)

> This was mostly typical of older hardware that did not have a PHY
> interrupt.

Many have to poll because the PHY interrupt is simply unreliable.
