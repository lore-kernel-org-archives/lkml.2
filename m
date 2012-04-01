Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2DAVZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:25:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2DAVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:25:02 -0400
Date: Sun, 01 Apr 2012 17:23:48 -0400 (EDT)
Message-Id: <20120401.172348.940488056538229210.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH] sparc: pgtable_64: change include order
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333306478-26266-1-git-send-email-aaro.koskinen@iki.fi>
References: <1333306478-26266-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 14:23:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Sun,  1 Apr 2012 21:54:38 +0300

> Fix the following build breakage in v3.4-rc1:
> 
 ...
> 
> Reported-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Applied, thanks a lot.
