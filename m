Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2CGCfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:35:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42214 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2CGCfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:35:21 -0500
Date: Tue, 06 Mar 2012 21:34:53 -0500 (EST)
Message-Id: <20120306.213453.700930266749202538.davem@davemloft.net>
To: tshimizu818@gmail.com
Cc: jeffrey.t.kirsher@intel.com, lucas.demarchi@profusion.mobi,
        mirq-linux@rere.qmqm.pl, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, john.stultz@linaro.org, richardcochran@gmail.com,
        arnd@arndb.de, khc@pm.waw.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH RE-SUBMIT] net/pch_gbe: supports eg20t ptp clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331079669-22446-1-git-send-email-tshimizu818@gmail.com>
References: <1331079669-22446-1-git-send-email-tshimizu818@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 18:34:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You still haven't submitted this properly.

First, you submitted the PCH_GBE driver changes before the EG20T
PTP clock driver which it depends upon.

Second, you didn't number your patches.  When you submit a patch
series you must number them so that there is no confusion about
what order those patches should be applied.
