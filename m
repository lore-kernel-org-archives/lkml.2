Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2CIV4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:56:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50733 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab2CIV4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:56:37 -0500
Date: Fri, 09 Mar 2012 13:56:24 -0800 (PST)
Message-Id: <20120309.135624.1280331660653754919.davem@davemloft.net>
To: tshimizu818@gmail.com
Cc: jeffrey.t.kirsher@intel.com, lucas.demarchi@profusion.mobi,
        mirq-linux@rere.qmqm.pl, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, john.stultz@linaro.org, richardcochran@gmail.com,
        arnd@arndb.de, khc@pm.waw.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH RE-SUBMIT 1/2] supports eg20t ptp clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331194587-29114-1-git-send-email-tshimizu818@gmail.com>
References: <1331194587-29114-1-git-send-email-tshimizu818@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 09 Mar 2012 13:56:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takahiro Shimizu <tshimizu818@gmail.com>
Date: Thu,  8 Mar 2012 17:16:26 +0900

> Supports EG20T ptp clock in the driver
> 
> Changes e-mail address.
> 
> Adds number.
> 
> Signed-off-by: Takahiro Shimizu <tshimizu818@gmail.com>

Applied, but I had to fix trailing empty lines you added to a file:

> +++ b/drivers/ptp/ptp_pch.c
> @@ -0,0 +1,731 @@
 ...
> +MODULE_DESCRIPTION("PTP clock using the EG20T timer");
> +MODULE_LICENSE("GPL");
> +

There.
