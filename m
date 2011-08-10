Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab1HJEL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:11:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1HJELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:11:55 -0400
Date: Tue, 09 Aug 2011 21:11:37 -0700 (PDT)
Message-Id: <20110809.211137.1412336654766141870.davem@davemloft.net>
To: joe@perches.com
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wangshaoyan.pt@taobao.com
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312949237.11924.58.camel@Joe-Laptop>
References: <1312943316.11924.54.camel@Joe-Laptop>
	<CANxBZFpm-at-FgNdP9nefwFfpzHmTMMsPSNWKJuT2R6TazhsYQ@mail.gmail.com>
	<1312949237.11924.58.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 09 Aug 2011 21:11:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 09 Aug 2011 21:07:17 -0700

> On Wed, 2011-08-10 at 11:50 +0800, Wang Shaoyan wrote:
>> Yes, I want to test, but I can't open CONFIG_GIANFAR, because I can't
>> find FSL_SOC, am i miss something?
> 
> A cross compiler for powerpc?

This is really misleading, because in the commit message the stack
usage message is reported but the patch submitted obviously didn't
generate that message since they can't even build test this change.

I'm not going to apply this until someone both build and functionally
tests this patch.
