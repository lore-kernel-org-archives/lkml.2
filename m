Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1GOPK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:10:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1GOPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:10:57 -0400
Date: Fri, 15 Jul 2011 08:10:45 -0700 (PDT)
Message-Id: <20110715.081045.395109170877608048.davem@davemloft.net>
To: Michael.Thalmeier@sigmatek.at
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michael@thalmeier.at
Subject: Re: [PATCH 1/1] r6040: only disable RX interrupt if
 napi_schedule_prep is successful
From: David Miller <davem@davemloft.net>
In-Reply-To: <1310729306-12190-1-git-send-email-Michael.Thalmeier@sigmatek.at>
References: <1310729306-12190-1-git-send-email-Michael.Thalmeier@sigmatek.at>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 15 Jul 2011 08:10:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Thalmeier <Michael.Thalmeier@sigmatek.at>
Date: Fri, 15 Jul 2011 13:28:26 +0200

> When receiving the first RX interrupt before the internal call
> to napi_schedule_prep is successful the RX interrupt gets disabled
> and is never enabled again as the poll function never gets executed.
> 
> Signed-off-by: Michael Thalmeier <Michael.Thalmeier@sigmatek.at>

Applied.
