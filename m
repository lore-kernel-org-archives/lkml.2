Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1ERVOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:14:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50875 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1ERVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:14:32 -0400
Date: Wed, 18 May 2011 17:14:16 -0400 (EDT)
Message-Id: <20110518.171416.1780927258138770742.davem@davemloft.net>
To: decot@google.com
Cc: joe@perches.com, szymon@janc.net.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        snanda@google.com
Subject: Re: [PATCH] forcedeth: new ethtool stat "tx_timeout" to account
 for tx_timeouts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305752945-14843-2-git-send-email-decot@google.com>
References: <1305752945-14843-1-git-send-email-decot@google.com>
	<1305752945-14843-2-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 14:14:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When submitting multiple patches in a patch set, NUMBER THEM.

Otherwise there is no unambiguous way to figure out what order
I should apply these patches.
