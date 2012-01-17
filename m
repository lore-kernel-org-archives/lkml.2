Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2AQPsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:48:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54837 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2AQPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:48:40 -0500
Date: Tue, 17 Jan 2012 10:48:25 -0500 (EST)
Message-Id: <20120117.104825.457549923860308778.davem@davemloft.net>
To: dmitry.antipov@linaro.org
Cc: steve.glendinning@smsc.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 3/3] smsc95xx: use usleep_range(), get rid out of
 jiffies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326804852-17742-1-git-send-email-dmitry.antipov@linaro.org>
References: <1326804852-17742-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 07:48:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Antipov <dmitry.antipov@linaro.org>
Date: Tue, 17 Jan 2012 16:54:12 +0400

> -/* Loop until the read is completed with timeout
> - * called with phy_mutex held */
> +/* Busy-wait loop until the read is completed, but
> +   no longer than 10ms. Called with phy_mutex held. */

Please:

	/* Write comments.
	 * Like this.
	 */
