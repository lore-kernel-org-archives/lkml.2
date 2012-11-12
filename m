Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2KLV1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:27:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37895 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2KLV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:27:29 -0500
Date: Mon, 12 Nov 2012 16:27:23 -0500 (EST)
Message-Id: <20121112.162723.264622334265396904.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, bhelgaas@google.com,
        hartleys@visionengravers.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, lethal@linux-sh.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
	<CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
	<20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 Nov 2012 08:26:15 +1100

> Make if easier for more architectures to select it and thus disable
> drivers that use virt_to_bus().
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
