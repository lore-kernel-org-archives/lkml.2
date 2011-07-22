Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1GVEey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:34:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48126 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1GVEex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:34:53 -0400
Date: Thu, 21 Jul 2011 21:34:49 -0700 (PDT)
Message-Id: <20110721.213449.773349592841572086.davem@davemloft.net>
To: jhbird.choi@samsung.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Kobj and queues_kset should be used when
 CONFIG_XPS is enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311229983-6081-1-git-send-email-jhbird.choi@samsung.com>
References: <1311229983-6081-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 21:34:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jhbird.choi@samsung.com
Date: Thu, 21 Jul 2011 15:33:03 +0900

> From: Choi, Jong-Hwan <jhbird.choi@samsung.com>
> 
> Kobj and queues_kset are used with CONFIG_XPS=y.
> 
> Signed-off-by: Choi, Jong-Hwan <jhbird.choi@samsung.com>

Applied.
