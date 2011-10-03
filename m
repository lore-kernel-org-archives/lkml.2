Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1JCS0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:26:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53221 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1JCS0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:26:04 -0400
Date: Mon, 03 Oct 2011 14:25:54 -0400 (EDT)
Message-Id: <20111003.142554.1957747149860835445.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/2] pch_gbe: Fixed the issue on which PC was frozen
 when link was downed.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317022063-12143-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
References: <1317022063-12143-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 03 Oct 2011 11:25:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Mon, 26 Sep 2011 16:27:42 +0900

> When a link was downed during network use,
> there is an issue on which PC freezes.
> 
> This patch fixed this issue.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

Applied.
