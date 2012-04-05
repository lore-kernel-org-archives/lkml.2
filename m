Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2DEEBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:01:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52563 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2DEEBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:01:46 -0400
Date: Wed, 04 Apr 2012 23:59:33 -0400 (EDT)
Message-Id: <20120404.235933.350585244341009071.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, deepak.sikri@st.com,
        shiraz.hashim@st.com, vikas.manocha@st.com, peppe.cavallaro@st.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120405132515.e61465875407a452c1a6f78e@canb.auug.org.au>
References: <20120405132515.e61465875407a452c1a6f78e@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 20:59:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Apr 2012 13:25:15 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: In function 'stmmac_probe_config_dt':
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:53:7: error: 'struct plat_stmmacenet_data' has no member named 'pbl'
> 
> Caused by commit 8327eb65e795 ("stmmac: re-work the internal GMAC DMA
> platf parameters").  Clearly I am missing something, because I can't see
> how that patch is correct since nothing ever assigns to the new dma_cfg
> pointer but it is dereferenced.
> 
> I have added this patch to make it build today, but it is obviously not
> correct.

Sorry Stephen.

Giuseppe don't submit patches to me that don't even compile.

Please submit a proper fix to me for this _now_.
