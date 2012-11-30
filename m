Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768809Ab2K3UDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:03:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46727 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab2K3UDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:03:10 -0500
Date: Fri, 30 Nov 2012 15:03:08 -0500 (EST)
Message-Id: <20121130.150308.1302355065124987824.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,1/1] hyperv: Add an error message to
 rndis_filter_set_device_mac()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354303421-26149-1-git-send-email-haiyangz@microsoft.com>
References: <1354303421-26149-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 30 Nov 2012 11:23:41 -0800

> This message indicates an error returned from the host when changing MAC address.
> 
> Reported-by: Michal Kubecek <mkubecek@suse.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
