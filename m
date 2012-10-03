Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2JCCfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:35:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53106 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2JCCfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:35:18 -0400
Date: Tue, 02 Oct 2012 22:35:17 -0400 (EDT)
Message-Id: <20121002.223517.307096403144373535.davem@davemloft.net>
To: hotforest@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: davinci_cpdma: decrease the desc count
 when cleaning up the remaining packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349145763-6292-1-git-send-email-hotforest@gmail.com>
References: <1349145763-6292-1-git-send-email-hotforest@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Hou <hotforest@gmail.com>
Date: Tue,  2 Oct 2012 10:42:43 +0800

> chan->count is used by rx channel. If the desc count is not updated by
> the clean up loop in cpdma_chan_stop, the value written to the rxfree
> register in cpdma_chan_start will be incorrect.
> 
> Signed-off-by: Tao Hou <hotforest@gmail.com>

Applied, thanks.
