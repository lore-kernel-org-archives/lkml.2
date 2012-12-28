Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2L1Xay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 18:30:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2L1Xav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 18:30:51 -0500
Date: Fri, 28 Dec 2012 15:30:50 -0800 (PST)
Message-Id: <20121228.153050.510027882505530294.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] forcedeth: Fix WARNINGS that result when DMA
 mapping is not checked
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356665141-4498-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356665141-4498-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 27 Dec 2012 21:25:41 -0600

> With 3.8-rc1, the first call of pci_map_single() that is not checked
> with a corresponding pci_dma_mapping_error() call results in a warning
> with a splat as follows:
> 
> WARNING: at lib/dma-debug.c:933 check_unmap+0x480/0x950()
> Hardware name: HP Pavilion dv2700 Notebook PC
> forcedeth 0000:00:0a.0: DMA-API: device driver failed to check
>  map error[device address=0x00000000b176e002] [size=90 bytes] [mapped as single]
> 
> Reviewed-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Applied, thanks Larry.
