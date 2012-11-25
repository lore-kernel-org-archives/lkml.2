Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2KYVMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 16:12:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40752 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2KYVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 16:12:29 -0500
Date: Sun, 25 Nov 2012 16:12:22 -0500 (EST)
Message-Id: <20121125.161222.556166144789386280.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: bhutchings@solarflare.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH V2 resend] net: dsa/slave: Fix compilation warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <ecc711bf44722707f57188ee953bbde2f1e20c8c.1353736229.git.viresh.kumar@linaro.org>
References: <ecc711bf44722707f57188ee953bbde2f1e20c8c.1353736229.git.viresh.kumar@linaro.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Sat, 24 Nov 2012 11:23:54 +0530

> Currently when none of CONFIG_NET_DSA_TAG_DSA, CONFIG_NET_DSA_TAG_EDSA and
> CONFIG_NET_DSA_TAG_TRAILER is defined, we get following compilation warnings:
> 
> net/dsa/slave.c:51:12: warning: 'dsa_slave_init' defined but not used [-Wunused-function]
> net/dsa/slave.c:60:12: warning: 'dsa_slave_open' defined but not used [-Wunused-function]
> net/dsa/slave.c:98:12: warning: 'dsa_slave_close' defined but not used [-Wunused-function]
> net/dsa/slave.c:116:13: warning: 'dsa_slave_change_rx_flags' defined but not used [-Wunused-function]
> net/dsa/slave.c:127:13: warning: 'dsa_slave_set_rx_mode' defined but not used [-Wunused-function]
> net/dsa/slave.c:136:12: warning: 'dsa_slave_set_mac_address' defined but not used [-Wunused-function]
> net/dsa/slave.c:164:12: warning: 'dsa_slave_ioctl' defined but not used [-Wunused-function]
> 
> Earlier approach to fix this was discussed here:
> 
> lkml.org/lkml/2012/10/29/549
> 
> This is another approach to fix it. This is done by some changes in config
> options, which make more sense than the earlier approach. As, atleast one
> tagging option must always be selected for using net/dsa/ infrastructure, this
> patch selects NET_DSA from tagging configs instead of having it as an selectable
> config.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied to net-next, thanks.
