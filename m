Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1DNUSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:18:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47300
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab1DNUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:18:42 -0400
Date: Thu, 14 Apr 2011 13:18:06 -0700 (PDT)
Message-Id: <20110414.131806.193709562.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-04-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110414200858.GC2652@tuxdriver.com>
References: <20110414200858.GC2652@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Apr 2011 16:08:58 -0400

> Another small round of fixes intended for 2.6.39...
> 
> Included are a fix for a WARNING from ath9k regarding a DMA failure, a
> fix for iwlegacy not initializing its Tx power correctly, and a small
> ath9k fix to report the driver name correctly to ethtool.

Pulled, thanks a lot John.

