Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2BOUvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:51:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60594 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2BOUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:51:15 -0500
Date: Wed, 15 Feb 2012 15:48:50 -0500 (EST)
Message-Id: <20120215.154850.1941243697037866035.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        swise@opengridcomputing.com, dwmw2@infradead.org,
        nhorman@tuxdriver.com
Subject: Re: [patch net-next] cxgb3: update firmware version
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120213202846.631.30806.stgit@speedy5.asicdesigners.com>
References: <20120213202846.631.30806.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 12:48:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 13 Feb 2012 12:28:46 -0800

> This patch updates the firmware version cxgb3 is requesting to 7.12.0.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

While I agree with Ben Hutchings that how this is being handled is terrible,
it's the current status-quo so I'll apply this.
