Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2HaTrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:47:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2HaTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:47:04 -0400
Date: Fri, 31 Aug 2012 15:47:01 -0400 (EDT)
Message-Id: <20120831.154701.958704113365912999.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: alex@linlab.net, hkjerry.chu@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120831.154234.735439593093335863.davem@davemloft.net>
References: <20120831124831.GA23279@linlab.net>
	<1346419550.2591.12.camel@edumazet-glaptop>
	<20120831.154234.735439593093335863.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 31 Aug 2012 15:42:34 -0400 (EDT)

> Applied with some minor comment formatting and wording adjustments.

BTW, please keep in mind that when you modify the value
of TCP_SYN_RETRIES, you are having an influence upon DCCP
as well.

TCP is not the only protocol which uses this value.

