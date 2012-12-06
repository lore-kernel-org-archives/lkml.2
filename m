Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2LFOXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:23:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40107 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2LFOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:23:15 -0500
MIME-Version: 1.0
Date: Thu, 6 Dec 2012 15:23:14 +0100
X-Google-Sender-Auth: ZESLV8gqm9EqjwPo1BntX1zhrJA
Message-ID: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com>
Subject: Sharing PCIE driver between Microblaze and Arm zynq
From: Michal Simek <michal.simek@xilinx.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Cc: John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I have a question regarding to sharing generic OF pcie driver between
two architectures MB and ARM Zynq.
Is drivers/pci/pcie location good for it?
Make no sense to have the same driver in two locations.
Is using readl/writel IO functions in this driver the best option
which we can have?
Or is there any other recommendation?

Also just want to check if it is correct to use pcie device_type.
The rest should be the same with pci description:
(http://devicetree.org/MPC5200:PCI#PCI_Address_Translation).

Thanks,
Michal
