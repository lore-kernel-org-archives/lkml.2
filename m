Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1HHFxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:53:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1HHFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:53:41 -0400
Date: Sun, 07 Aug 2011 22:53:37 -0700 (PDT)
Message-Id: <20110807.225337.661560107256045057.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] dp83640: increase receive time stamp buffer size
From: David Miller <davem@davemloft.net>
In-Reply-To: <d38d5b44e8894387852a116492cb825159b5842c.1312699694.git.richard.cochran@omicron.at>
References: <cover.1312699693.git.richard.cochran@omicron.at>
	<cover.1312699693.git.richard.cochran@omicron.at>
	<d38d5b44e8894387852a116492cb825159b5842c.1312699694.git.richard.cochran@omicron.at>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 22:53:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun,  7 Aug 2011 09:03:04 +0200

> The dp83640 buffers receive time stamps from special PHY status frames,
> matching them to received PTP packets in a work queue. Because the timeout
> for orphaned time stamps is so long and the buffer is so small, the driver
> can drop time stamps under moderate PTP traffic.
> 
> This commit fixes the issue by decreasing the timeout to (at least) one
> timer tick and increasing the buffer size.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: <stable@kernel.org>

Applied.
