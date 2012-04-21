Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2DUTa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:30:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43386 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2DUTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:30:26 -0400
Date: Sat, 21 Apr 2012 15:29:23 -0400 (EDT)
Message-Id: <20120421.152923.1556933817051385385.davem@davemloft.net>
To: mathieu.poirier@linaro.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 0/8] drivers/net: randconfig patches for kernel 3.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
References: <1334955376-17793-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Apr 2012 12:29:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mathieu.poirier@linaro.org
Date: Fri, 20 Apr 2012 14:56:08 -0600

> From: Arnd Bergmann <arnd@arndb.de>
> 
> These patches fix miscellaneous problems when working
> with make randconfig.  They were discovered on kernel
> 3.1-rc4 and have been reformatted for 3.3.

All applied to net-next, thanks.
