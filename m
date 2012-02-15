Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2BOFL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:11:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52380 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2BOFL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:11:56 -0500
Date: Wed, 15 Feb 2012 00:11:51 -0500 (EST)
Message-Id: <20120215.001151.565149015153391199.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] arch/sparc: remove references to cpu_*_map.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329281884.6232.rusty@rustcorp.com.au>
References: <1329281884.6232.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 14 Feb 2012 21:11:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> This has been obsolescent for a while; time for the final push.
> 
> Also get rid of obsolescent first_cpu().
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David S. Miller <davem@davemloft.net>
