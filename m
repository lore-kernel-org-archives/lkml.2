Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1DZTo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:44:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48363
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074Ab1DZTo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:44:27 -0400
Date: Tue, 26 Apr 2011 12:43:54 -0700 (PDT)
Message-Id: <20110426.124354.71125507.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, hayeswang@realtek.com,
        romieu@fr.zoreil.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110426135146.c01f8395.sfr@canb.auug.org.au>
References: <20110426135146.c01f8395.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Apr 2011 13:51:46 +1000

> Hi all,
> 
> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/r8169.c: In function 'rtl8168e_1_hw_phy_config':
> drivers/net/r8169.c:2578: error: too many arguments to function 'rtl_apply_firmware'
> drivers/net/r8169.c:2578: error: void value not ignored as it ought to be
> drivers/net/r8169.c: In function 'rtl8168e_2_hw_phy_config':
> drivers/net/r8169.c:2586: error: too many arguments to function 'rtl_apply_firmware'
> drivers/net/r8169.c:2586: error: void value not ignored as it ought to be
> 
> Caused by commit 953a12cc2889 ("r8169: don't request firmware when
> there's no userspace") from the net-current tree interacting with commit
> 01dc7fec4025 ("net/r8169: support RTL8168E").
> 
> I applied the following fixup patch:

Stephen, I just merged net-2.6 into net-next-2.6 and added your patch
to the merge commit to make sure the build is fine.

Thanks a lot!
