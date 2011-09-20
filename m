Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1ITTph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:45:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1ITTpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:45:36 -0400
Date: Tue, 20 Sep 2011 15:45:28 -0400 (EDT)
Message-Id: <20110920.154528.2085500980809143629.davem@davemloft.net>
To: ming.m.lin@intel.com
Cc: akpm00@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH -v2] netconsole: switch init_netconsole() to
 late_initcall if build-in
From: David Miller <davem@davemloft.net>
In-Reply-To: <1315903130.3375.7.camel@snb>
References: <1315899939.3402.2.camel@snb>
	<20110913010158.1652cdee.akpm@linux-foundation.org>
	<1315903130.3375.7.camel@snb>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Sep 2011 12:45:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>
Date: Tue, 13 Sep 2011 16:38:50 +0800

> Subject: [PATCH -v3] netconsole: switch init_netconsole() to late_initcall
> 
> Commit 88491d8(drivers/net: Kconfig & Makefile cleanup) causes a
> regression that netconsole does not work if netconsole and network
> device driver are build into kernel, because netconsole is linked
> before network device driver.
> 
> Andrew Morton suggested to fix this with initcall ordering.
> Fixes it by switching init_netconsole() to late_initcall.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Applied, thanks.
