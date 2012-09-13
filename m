Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2IMVFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:05:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49474 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab2IMVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:05:46 -0400
Date: Thu, 13 Sep 2012 17:05:44 -0400 (EDT)
Message-Id: <20120913.170544.700934810225924264.davem@davemloft.net>
To: tilman@imap.cc
Cc: peter.senna@gmail.com, hjlipp@web.de, kernel-janitors@vger.kernel.org,
        isdn@linux-pingi.de, gigaset307x-common@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] drivers/isdn/gigaset/common.c: Remove useless kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <5051ACDB.5030407@imap.cc>
References: <1347462407-13499-9-git-send-email-peter.senna@gmail.com>
	<5051ACDB.5030407@imap.cc>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Thu, 13 Sep 2012 11:52:27 +0200

> Am 12.09.2012 17:06, schrieb Peter Senna Tschudin:
>> From: Peter Senna Tschudin <peter.senna@gmail.com>
>> 
>> Remove useless kfree() and clean up code related to the removal.
>> 
>> The semantic patch that finds this problem is as follows:
> [...]
>> 
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Acked-by: Tilman Schmidt <tilman@imap.cc>

Applied to net-next, thanks.
