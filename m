Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1LDTAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38360 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab1LDTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:46 -0500
Date: Sun, 04 Dec 2011 14:00:39 -0500 (EST)
Message-Id: <20111204.140039.171261237123447589.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sbus: convert drivers/sbus/char/* to use
 module_platform_driver()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322370265.2522.5.camel@phoenix>
References: <1322370265.2522.5.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 04 Dec 2011 11:00:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 27 Nov 2011 13:04:25 +0800

> This patch converts the drivers in drivers/sbus/char/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.
