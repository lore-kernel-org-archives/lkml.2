Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab2BBTuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:50:55 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab2BBTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:50:54 -0500
Date: Thu, 02 Feb 2012 14:50:49 -0500 (EST)
Message-Id: <20120202.145049.1266443194879118640.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/hyperv: Fix the page buffer when an RNDIS
 message goes beyond page boundary
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328203080-801-2-git-send-email-haiyangz@microsoft.com>
References: <1328203080-801-1-git-send-email-haiyangz@microsoft.com>
	<1328203080-801-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Feb 2012 11:50:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu,  2 Feb 2012 09:18:00 -0800

> There is a possible data corruption if an RNDIS message goes beyond page
> boundary in the sending code path. This patch fixes the problem.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
