Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2JAWjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:39:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JAWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:39:22 -0400
Date: Mon, 01 Oct 2012 18:39:19 -0400 (EDT)
Message-Id: <20121001.183919.1364005468105446885.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net,1/3] hyperv: Fix the max_xfer_size in RNDIS
 initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches do not apply cleanly to the current net-next tree
which is the only place where patches should be targetted right
now.
