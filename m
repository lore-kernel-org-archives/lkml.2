Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1KNFde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:33:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49809 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1KNFdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:33:32 -0500
Date: Mon, 14 Nov 2011 00:33:22 -0500 (EST)
Message-Id: <20111114.003322.1579175313793306922.davem@davemloft.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com
Subject: Re: [PATCH V2 2/6] net/ethernet/atl1e: Disable ASPM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111114.003113.40819474361221233.davem@davemloft.net>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
	<1321028064-644-3-git-send-email-mjg@redhat.com>
	<20111114.003113.40819474361221233.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:33:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAE5XfIs017038

From: David Miller <davem@davemloft.net>
Date: Mon, 14 Nov 2011 00:31:13 -0500 (EST)

> From: Matthew Garrett <mjg@redhat.com>
> Date: Fri, 11 Nov 2011 11:14:20 -0500
> 
>> http://www.atheros.cz/atheros-inf-file.php?inf=209&chipset=45&system=6
>> indicates that ASPM is disabled on all L1E hardware. Duplicate for sanity.
>> 
>> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Applied.

Ummm, -ENOBUILDTESTING?!??!

drivers/net/ethernet/atheros/atl1e/atl1e_main.c: In function ¡atl1e_probe¢:
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:2267:2: error: implicit declaration of function ¡pci_disable_link_state¢ [-Werror=implicit-function-declaration]
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:2267:31: error: ¡PCIE_LINK_STATE_L0S¢ undeclared (first use in this function)
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:2267:31: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:2267:53: error: ¡PCIE_LINK_STATE_L1¢ undeclared (first use in this function)
drivers/net/ethernet/atheros/atl1e/atl1e_main.c:2268:11: error: ¡PCIE_LINK_STATE_CLKPM¢ undeclared (first use in this function)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
