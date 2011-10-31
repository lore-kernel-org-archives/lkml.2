Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1JaWAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:00:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38706 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1JaWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:00:00 -0400
Date: Mon, 31 Oct 2011 17:57:43 -0400 (EDT)
Message-Id: <20111031.175743.115974002318620455.davem@davemloft.net>
To: joe@perches.com
Cc: bharrosh@panasas.com, jbaron@redhat.com, philb@gnu.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        randy.dunlap@oracle.com, sfr@canb.auug.org.au
Subject: Re: [PATCH] 3c505: Fix compile breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320097524.4399.8.camel@Joe-Laptop>
References: <4EAF0F34.4070702@panasas.com>
	<1320097524.4399.8.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 31 Oct 2011 14:57:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 31 Oct 2011 23:45:24 +0200

> The joys of preprocessor games with c90 named initializers.
> 
> commit 07613b0b5ef8
> ("dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions")
> uses a ".filename" named initializer.
> 
> When filename is also a #define this fails to compile.
> 
> Remove #define filename from 3c505.c
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Andrew Morton submitted a fix for this earlier today.

http://marc.info/?l=linux-netdev&m=132009089027792&w=2
