Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab2KTSho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:37:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42444 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2KTShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:37:42 -0500
Date: Tue, 20 Nov 2012 13:37:40 -0500 (EST)
Message-Id: <20121120.133740.2078663535446438063.davem@davemloft.net>
To: tj@kernel.org
Cc: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHSET REPOST v2 cgroup/for-3.8] netcls/prio_cgroup: update
 hierarchy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353400211-5182-1-git-send-email-tj@kernel.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 20 Nov 2012 00:30:04 -0800

>  0001-netcls_cgroup-move-config-inheritance-to-css_online-.patch
>  0002-netprio_cgroup-simplify-write_priomap.patch
>  0003-netprio_cgroup-shorten-variable-names-in-extend_netd.patch
>  0004-netprio_cgroup-reimplement-priomap-expansion.patch
>  0005-netprio_cgroup-use-cgroup-id-instead-of-cgroup_netpr.patch
>  0006-netprio_cgroup-implement-netprio-_set-_prio-helpers.patch
>  0007-netprio_cgroup-allow-nesting-and-inherit-config-on-c.patch

For series:

Acked-by: David S. Miller <davem@davemloft.net>
