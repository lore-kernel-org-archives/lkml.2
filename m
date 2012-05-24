Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab2EXE1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:27:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2EXE1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:27:24 -0400
Date: Thu, 24 May 2012 00:27:15 -0400 (EDT)
Message-Id: <20120524.002715.1797111882951289657.davem@davemloft.net>
To: tim.bird@am.sony.com
Cc: eric.dumazet@gmail.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: add a low limit to alloc_large_system_hash
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FBD73CF.2000306@am.sony.com>
References: <4FBD73CF.2000306@am.sony.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 May 2012 21:27:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tim.bird@am.sony.com>
Date: Wed, 23 May 2012 16:33:35 -0700

> This patch seems to have fallen in the cracks:
> 
> https://lkml.org/lkml/2012/2/27/20
> 
> The last message on the thread was an ACK by David Miller, and
> the question "Who wants to take this?"

I'll take it in via my 'net' tree, thanks Tim.
