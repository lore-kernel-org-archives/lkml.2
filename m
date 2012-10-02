Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2JBSmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:42:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49836 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2JBSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:42:07 -0400
Date: Tue, 02 Oct 2012 14:42:05 -0400 (EDT)
Message-Id: <20121002.144205.475981870169341463.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,2/6] hyperv: Fix the missing return value in
 rndis_filter_set_packet_filter()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349191824-14001-2-git-send-email-haiyangz@microsoft.com>
References: <1349191824-14001-1-git-send-email-haiyangz@microsoft.com>
	<1349191824-14001-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue,  2 Oct 2012 08:30:20 -0700

> Return ETIMEDOUT when the reply message is not received in time.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
