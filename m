Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0IBCRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:17:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59347
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab0IBCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:17:30 -0400
Date: Wed, 01 Sep 2010 19:17:46 -0700 (PDT)
Message-Id: <20100901.191746.256848727.davem@davemloft.net>
To: bandan.das@stratus.com
Cc: herbert@gondor.hengli.com.au, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100902020545.GC17843@stratus.com>
References: <20100901233056.GA15177@gondor.apana.org.au>
	<20100901.180922.163252387.davem@davemloft.net>
	<20100902020545.GC17843@stratus.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bandan.das@stratus.com>
Date: Wed, 1 Sep 2010 22:05:45 -0400

> Sounds good, except for one thing :)
> It should be:  Reported-by: Bandan Das <bandan.das@stratus.com> (without the "r")

Fixed, thanks!
