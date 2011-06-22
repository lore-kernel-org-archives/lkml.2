Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1FVCta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:49:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1FVCt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:49:29 -0400
Date: Tue, 21 Jun 2011 19:49:25 -0700 (PDT)
Message-Id: <20110621.194925.1313933193955144936.davem@davemloft.net>
To: greg@kroah.com
CC: linux-kernel@vger.kernel.org
Subject: comedi doesn't build on several architectures
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Jun 2011 19:49:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It depends upon PAGE_KERNEL_NOCACHE which only a handful of
platforms define.

Really, enabling staging in Linus's tree with all this build fallout
was not the wisest.  It's blowing up all of my allmodconfig test
builds now.

Stick it to -next first next time.
