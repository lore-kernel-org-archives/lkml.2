Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2ECRGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:06:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2ECRGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:06:31 -0400
Date: Thu, 03 May 2012 13:06:11 -0400 (EDT)
Message-Id: <20120503.130611.160512784868698446.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 00/16] Swap-over-NBD without deadlocking V9
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503150048.GI11435@suse.de>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de>
	<20120501152826.b970a098.akpm@linux-foundation.org>
	<20120503150048.GI11435@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 10:06:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 3 May 2012 16:00:48 +0100

> Any of the networking people care to comment?

Post another series with any lingering feedback you've received and
I'll make sure it gets queued up in patchwork so that it gets properly
reviewed by us.

Thanks.
