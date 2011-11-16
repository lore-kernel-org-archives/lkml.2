Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1KPNl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:41:27 -0500
Received: from mxout1.idt.com ([157.165.5.25]:32777 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328Ab1KPNlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:41:25 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/5,v3] powerpc/85xx: Update SRIO device tree nodes
Date: Wed, 16 Nov 2011 05:40:15 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917CD@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1321099352-21462-3-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/5,v3] powerpc/85xx: Update SRIO device tree nodes
Thread-Index: AcyhMw3k04HPWHNVTBG6KiLXxdySmADMiPyg
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-3-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Liu Gang [mailto:Gang.Liu@freescale.com]
> Sent: Saturday, November 12, 2011 7:03 AM
> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> r58472@freescale.com; B11780@freescale.com; r61911@freescale.com;
Kumar
> Gala
> Subject: [PATCH 3/5,v3] powerpc/85xx: Update SRIO device tree nodes
> 
> From: Kumar Gala <galak@kernel.crashing.org>
> 
> Update all dts files that support SRIO controllers to match the new
> fsl,srio device tree binding.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  arch/powerpc/boot/dts/mpc8568mds.dts   |   66
++++++++++++++++++++++--
> -----
>  arch/powerpc/boot/dts/mpc8569mds.dts   |   72
> +++++++++++++++++++++++++------
>  arch/powerpc/boot/dts/mpc8641_hpcn.dts |   69
> ++++++++++++++++++++++++-------
>  arch/powerpc/boot/dts/p2041rdb.dts     |   11 +++++
>  arch/powerpc/boot/dts/p2041si.dtsi     |   20 +++++++++
>  arch/powerpc/boot/dts/p3041ds.dts      |   11 +++++
>  arch/powerpc/boot/dts/p3041si.dtsi     |   26 ++++++++---
>  arch/powerpc/boot/dts/p4080ds.dts      |   12 ++++-
>  arch/powerpc/boot/dts/p4080si.dtsi     |   64
+++++++++++++++++++++++-
> ----
>  arch/powerpc/boot/dts/p5020ds.dts      |   11 +++++
>  arch/powerpc/boot/dts/p5020si.dtsi     |   26 ++++++++---
>  11 files changed, 314 insertions(+), 74 deletions(-)
> 

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

