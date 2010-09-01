Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0IAD5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 23:57:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36540
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab0IAD5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 23:57:07 -0400
Date: Tue, 31 Aug 2010 20:57:23 -0700 (PDT)
Message-Id: <20100831.205723.43021492.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: linux-next: build warnings after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100901112501.570e06a1.sfr@canb.auug.org.au>
References: <20100831115508.078eb2fa.sfr@canb.auug.org.au>
	<20100830.215641.71568585.davem@davemloft.net>
	<20100901112501.570e06a1.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Sep 2010 11:25:01 +1000

> However, I missed one yesterday ...
> 
> drivers/net/stmmac/dwmac100_core.c: In function 'dwmac100_dump_mac_regs':
> drivers/net/stmmac/dwmac100_core.c:47: warning: cast from pointer to integer of different size

Thanks I'll take care of this.
