Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2CEF5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 00:57:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48881 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2CEF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 00:57:21 -0500
Date: Mon, 05 Mar 2012 00:57:09 -0500 (EST)
Message-Id: <20120305.005709.1597475617000728984.davem@davemloft.net>
To: tshimizu818@gmail.com
Cc: jeffrey.t.kirsher@intel.com, lucas.demarchi@profusion.mobi,
        mirq-linux@rere.qmqm.pl, paul.gortmaker@windriver.com,
        toshiharu-linux@dsn.okisemi.com, jdmason@kudzu.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] net/pch_gbe: supports eg20t ptp clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330926377-11531-1-git-send-email-tshimizu818@gmail.com>
References: <1330926377-11531-1-git-send-email-tshimizu818@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 04 Mar 2012 21:57:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So how the heck is this supposed to work?

You post a patch for the e20tp clock source, you don't CC: netdev.

Then you post this network driver patch which depends upon that on
and you do CC: netdev.

You've made it impossible for me to apply them both properly into my
tree so that the dependency goes in.
