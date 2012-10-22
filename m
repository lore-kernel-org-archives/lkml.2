Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2JVAgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:36:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54813 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2JVAgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:36:04 -0400
Date: Sun, 21 Oct 2012 20:36:01 -0400 (EDT)
Message-Id: <20121021.203601.887733994766774819.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,1/1] hyperv: Remove unnecessary comments in
 rndis_filter_receive_data()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350594052-15714-1-git-send-email-haiyangz@microsoft.com>
References: <1350594052-15714-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 18 Oct 2012 14:00:52 -0700

> Checked with Windows networking team, there is only one RNDIS message
> in each netvsc packet.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
