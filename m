Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2HQCkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:40:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HQCkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:40:02 -0400
Date: Thu, 16 Aug 2012 19:39:56 -0700 (PDT)
Message-Id: <20120816.193956.526349200422426116.davem@davemloft.net>
To: fan.du@windriver.com
Cc: fengguang.wu@intel.com, Priyanka.Jain@freescale.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: suspicious RCU usage in xfrm_net_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <502D9938.2010908@windriver.com>
References: <502CBF23.4070805@windriver.com>
	<20120816151949.GA18681@localhost>
	<502D9938.2010908@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Du <fan.du@windriver.com>
Date: Fri, 17 Aug 2012 09:07:04 +0800

> Could you please pick up this patch?

Done, but could you please put proper prefixes in your commit
message subject lines?  I had to prepend "xfrm: " this time.
