Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1FQDtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:49:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab1FQDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:49:42 -0400
Date: Thu, 16 Jun 2011 23:48:29 -0400 (EDT)
Message-Id: <20110616.234829.1329947216240796818.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH for 3.0-rc4 0/2] dp83640: bug fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1308129342.git.richard.cochran@omicron.at>
References: <cover.1308129342.git.richard.cochran@omicron.at>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 20:48:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Wed, 15 Jun 2011 11:55:18 +0200

> This series fixes two status frame related bugs in the driver for the
> dp83640 phy. I am not sure whether you would call this a timer fix or
> a networking fix, so I put both groups on CC.

I've applied both to net-2.6, thanks.
