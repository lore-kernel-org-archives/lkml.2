Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2K0LXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:23:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36520 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab2K0LXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:23:16 -0500
Message-ID: <50B4A274.5070601@ti.com>
Date: Tue, 27 Nov 2012 16:52:28 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Jon Hunter <jon-hunter@ti.com>, Afzal Mohammed <afzal@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the net-next
 tree
References: <20121126204546.ef1f1b55e903eda38a61d5d1@canb.auug.org.au>
In-Reply-To: <20121126204546.ef1f1b55e903eda38a61d5d1@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 3:15 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/am33xx.dtsi between commit 1a39a65cba08 ("arm/dts:
> am33xx: Add CPSW and MDIO module nodes for AM33XX") from the net-next
> tree and commits 059b185d5345 ("ARM: dts: AM33XX: Add D_CAN device tree
> data") and 4c94ac29b5c1 ("ARM: dts: OMAP: Move interrupt-parent to the
> root node to avoid duplication") (and a few others that added more later
> nodes) from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
Stephen Rothwell

The fix is correct and I have tested CPSW from linux-next.

Regards
Mugunthan V N

