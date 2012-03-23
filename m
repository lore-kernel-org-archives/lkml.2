Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2CWCfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:35:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CWCf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:35:29 -0400
Date: Thu, 22 Mar 2012 22:35:01 -0400 (EDT)
Message-Id: <20120322.223501.1670921652591691525.davem@davemloft.net>
To: tshimizu818@gmail.com
Cc: jeffrey.t.kirsher@intel.com, lucas.demarchi@profusion.mobi,
        mirq-linux@rere.qmqm.pl, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, john.stultz@linaro.org, richardcochran@gmail.com,
        arnd@arndb.de, khc@pm.waw.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] ptp/ptp_pch: Modified according to the mainter's
 comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332468760-2525-1-git-send-email-tshimizu818@gmail.com>
References: <1332468760-2525-1-git-send-email-tshimizu818@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Mar 2012 19:35:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You've sent three sets of patches.

And you've numbered them individually within each set.

And this is totally confusing.

Does one set need to be applied before another set?  And if so,
in what order.

I'm tossing all of your patches, submit your changes properly,
orderred together as one single set of numberred patches.

