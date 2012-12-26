Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2LZWQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:16:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35466 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LZWQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:16:50 -0500
Date: Wed, 26 Dec 2012 14:16:42 -0800 (PST)
Message-Id: <20121226.141642.2212856687052645929.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: lizefan@huawei.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] netprio_cgroup: define sk_cgrp_prioidx only if
 NETPRIO_CGROUP is enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121226180339.GB10793@neilslaptop.think-freely.org>
References: <50DA9DB8.6080506@huawei.com>
	<20121226180339.GB10793@neilslaptop.think-freely.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 26 Dec 2012 13:03:39 -0500

> On Wed, Dec 26, 2012 at 02:48:24PM +0800, Li Zefan wrote:
>> sock->sk_cgrp_prioidx won't be used at all if CONFIG_NETPRIO_CGROUP=n.
>> 
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks.
