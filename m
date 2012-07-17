Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2GQFy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:54:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2GQFyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:54:55 -0400
Date: Mon, 16 Jul 2012 22:54:53 -0700 (PDT)
Message-Id: <20120716.225453.1695509038616478796.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH net,1/1] hyperv: Add support for setting MAC from
 within guests
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341940762-18307-1-git-send-email-haiyangz@microsoft.com>
References: <1341940762-18307-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 10 Jul 2012 10:19:22 -0700

> This adds support for setting synthetic NIC MAC address from within Linux
> guests. Before using this feature, the option "spoofing of MAC address"
> should be enabled at the Hyper-V manager / Settings of the synthetic
> NIC.
> 
> Thanks to Kin Cho <kcho@infoblox.com> for the initial implementation and
> tests. And, thanks to Long Li <longli@microsoft.com> for the debugging
> works.
> 
> Reported-and-tested-by: Kin Cho <kcho@infoblox.com>
> Reported-by: Long Li <longli@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied to net-next, thanks.
