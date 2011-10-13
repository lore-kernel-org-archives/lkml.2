Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1JMQdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:33:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3167 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1JMQdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:33:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Oct 2011 09:33:02 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Oct 2011 09:33:01 -0700
Subject: RE: [PATCH] i2c: tegra: __iomem annotation fix
Thread-Topic: [PATCH] i2c: tegra: __iomem annotation fix
Thread-Index: AcyJP7IJuUQdP15bSOuTZx7+1rL8pQAhfkWg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A088@HQMAIL01.nvidia.com>
References: <1318465980-625-1-git-send-email-olof@lixom.net>
In-Reply-To: <1318465980-625-1-git-send-email-olof@lixom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Wednesday, October 12, 2011 6:33 PM:
> drivers/i2c/busses/i2c-tegra.c:585:7: warning: incorrect type in assignment (different address spaces)
> drivers/i2c/busses/i2c-tegra.c:585:7:    expected void *base
> drivers/i2c/busses/i2c-tegra.c:585:7:    got void [noderef] <asn:2>*
> drivers/i2c/busses/i2c-tegra.c:619:16: warning: incorrect type in assignment (different address
> spaces)
> drivers/i2c/busses/i2c-tegra.c:619:16:    expected void [noderef] <asn:2>*base
> drivers/i2c/busses/i2c-tegra.c:619:16:    got void *base
> drivers/i2c/busses/i2c-tegra.c:689:10: warning: incorrect type in argument 1 (different address
> spaces)
> drivers/i2c/busses/i2c-tegra.c:689:10:    expected void volatile [noderef] <asn:2>*addr
> drivers/i2c/busses/i2c-tegra.c:689:10:    got void *base
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

