Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab2J2Ppx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:45:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43229 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2J2Ppw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:45:52 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Topic: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Index: AQHNpvQIuOsYud0XskqrLRNTKR4CVJfQieKQ
Date: Mon, 29 Oct 2012 15:45:36 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
In-Reply-To: <1349879449-22657-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Wed, Oct 10, 2012 at 20:00:49, Porter, Matt wrote:
> 6ea74cb ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
> exposes a bug in the AM33XX clock data for mcasp. After moving to
> clk_get() usage, the _init() of all registered hwmods fails on mcasp0
> due to incorrect clock data causing clk_get() to fail. This causes all
> successive hwmods to fail to _init() leaving them in a bad state.
> 
> This patch updates the mcasp clock entries so clk_get() will succeed.
> It is tested on BeagleBone and is needed for 3.7-rc1 to fix AM33xx
> boot.


I want to test Audio on AM335x Evm with your EDMA patches. I have few 
patches for AM335x.
Can you share the link to the repo & branch on which I need to rebase?
The patches are related to mcasp dt node, mcasp pinmux in dt, etc...

> 
..snip..
..snip..
> 


Thanks & Regards, 
Gururaja
