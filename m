Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1KPNsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:48:25 -0500
Received: from mxout1.idt.com ([157.165.5.25]:33046 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1KPNsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:48:24 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/5,v3] powerpc/8xxx: Update device tree bus probe for new RapidIO node binding
Date: Wed, 16 Nov 2011 05:48:09 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917D5@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1321099352-21462-4-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5,v3] powerpc/8xxx: Update device tree bus probe for new RapidIO node binding
Thread-Index: AcyhMwuZxi91m5OrTMW8LFQ61EBrXgDM0hXQ
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-4-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Kai Jiang <Kai.Jiang@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Liu Gang [mailto:Gang.Liu@freescale.com]
> Sent: Saturday, November 12, 2011 7:03 AM
> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> r58472@freescale.com; B11780@freescale.com; r61911@freescale.com; Kai
> Jiang; Kumar Gala
> Subject: [PATCH 4/5,v3] powerpc/8xxx: Update device tree bus probe for
> new RapidIO node binding
> 
> From: Kai Jiang <Kai.Jiang@freescale.com>
> 
> Update of_platform_bus_probe() RapidIO node to be compitable with
> new RapidIO dts compatible property.
> 
> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  arch/powerpc/platforms/85xx/corenet_ds.c   |    2 +-
>  arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
>  arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

