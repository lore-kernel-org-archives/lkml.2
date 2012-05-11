Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2EKFE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:04:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57229 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2EKFE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:04:57 -0400
Date: Fri, 11 May 2012 01:04:45 -0400 (EDT)
Message-Id: <20120511.010445.1020972261904383892.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 00/17] Swap-over-NBD without deadlocking V10
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-1-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 22:04:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I'm generally happy with the networking parts.

If you address my feedback I'll sign off on it.

The next question is whose tree this stuff goes through :-)
