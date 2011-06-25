Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1FYAdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 20:33:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53384 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FYAdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 20:33:00 -0400
Date: Fri, 24 Jun 2011 17:31:52 -0700 (PDT)
Message-Id: <20110624.173152.1603347362416638729.davem@davemloft.net>
To: joe@perches.com
Cc: geert@linux-m68k.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] 8390: Neatening
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1308810463.git.joe@perches.com>
References: <cover.1308810463.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Jun 2011 17:31:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 22 Jun 2011 23:38:52 -0700

> Some updates requested by Geert Uytterhoeven
> 
> Joe Perches (8):
>   ariadne: Update style, neaten, restructure to eliminate prototypes
>   a2065: Use pr_fmt, pr_<level> and netdev_<level>
>   lib8390: Use pr_<level> and netdev_<level>
>   lib8390: Indent braces appropriately
>   lib8390: Normalize source code spacing
>   lib8390: Convert include <asm to include <linux
>   lib8390: Remove unnecessary extern
>   zorro8390: Restructure and eliminate prototypes

All applied, thanks Joe.
