Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2C0W4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:56:50 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:50257 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040Ab2C0W4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:56:49 -0400
Date: Wed, 28 Mar 2012 00:54:07 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] r8169: modify pll power function
Message-ID: <20120327225407.GB22177@electric-eye.fr.zoreil.com>
References: <1332834834-5185-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332834834-5185-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Adjust r810x_pll_power_down, r810x_pll_power_up, and r8168_pll_power_up.
> Always power up device during rtl_open.
> For r810x, turn off more power when the WOL is disabled.

Would the "Always power up" part qualify as a "fix something" change ?

-- 
Ueimor
