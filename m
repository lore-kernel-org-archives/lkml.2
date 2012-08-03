Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2HCXwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:52:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2HCXwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:52:13 -0400
Date: Fri, 03 Aug 2012 16:52:12 -0700 (PDT)
Message-Id: <20120803.165212.106382119661240198.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,1/1] hyperv: Move wait completion msg code
 into rndis_filter_halt_device()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344022338-3010-1-git-send-email-haiyangz@microsoft.com>
References: <1344022338-3010-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri,  3 Aug 2012 12:32:18 -0700

> We need to wait for send_completion msg before put_rndis_request() at
> the end of rndis_filter_halt_device(). Otherwise, netvsc_send_completion()
> may reference freed memory which is overwritten, and cause panic.
> 
> Reported-by: Long Li <longli@microsoft.com>
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

This is a bug fix, so applied to 'net'.  Please target your patches
properly.

Don't just be afraid that I'll reject the patch if you target it
at 'net', and therefore just target everything at 'net-next'.  That
is certainly worse.


