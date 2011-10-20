Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1JTJZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:25:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56066 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1JTJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:25:08 -0400
Date: Thu, 20 Oct 2011 05:25:06 -0400 (EDT)
Message-Id: <20111020.052506.373437241768777548.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: rodrigue@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
	<20111020.044541.970282389722164761.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 02:25:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ren, Cloud" <cjren@qca.qualcomm.com>
Date: Thu, 20 Oct 2011 09:23:07 +0000

> As you saw, should I do the two following steps?
> 1. I firstly try to submit code to linux-staging.git. 
> 2. After the driver have been accepted by  linux-staging.git, I submit to net-next.git again.

You submit and get it into staging so that it can sit there for some
time and get reviewed and improved by others.

One doesn't submit directly to net-next right after it gets into
staging, staging is a place where your driver lives while it still
smelly funky and needs more work.
