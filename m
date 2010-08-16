Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0HPU4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:56:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47919
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab0HPU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:56:06 -0400
Date: Mon, 16 Aug 2010 13:56:22 -0700 (PDT)
Message-Id: <20100816.135622.214236113.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-08-16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100816203440.GG2656@tuxdriver.com>
References: <20100816203440.GG2656@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 16 Aug 2010 16:34:41 -0400

> This group of fixes is intended for 2.6.36.  This includes a fix for a
> warning backtrace related to pm_qos in ipw2100, a packet injection oops
> for ath9k_htc, a connectivity regression for ath9k_htc related to HT
> capabilities handling, a scanning regression in wl1251, 
> a firmware loading error in ath9k_htc, and a patch to disable L0s for
> all ath5k cards (causes misc wierdness).

Pulled, thanks a lot John.
