Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2FKXml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:42:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2FKXmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:42:40 -0400
Date: Mon, 11 Jun 2012 16:42:39 -0700 (PDT)
Message-Id: <20120611.164239.604207264181849443.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: ethan.kernel@gmail.com, eric.dumazet@gmail.com, lists@nerdbynature.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: tg3: transmit timed out, resetting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120607225654.GA14247@mcarlson.broadcom.com>
References: <1338955977.2760.3603.camel@edumazet-glaptop>
	<CABawtvOBJQ-oajFQmviOdgKCub-4n06kRW+x7nE2uyiWnoky9Q@mail.gmail.com>
	<20120607225654.GA14247@mcarlson.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Thu, 7 Jun 2012 15:56:54 -0700

> Does the following patch fix your problem?
> 
> 
> [PATCH] tg3: Apply short DMA frag workaround to 5906
> 
> 5906 devices also need the short DMA fragment workaround.  This patch
> makes the necessary change.
> 
> Signed-off-by: Matt Carlson <mcarlson@broadcom.com>

Ping, what's the status of this?
