Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1KPNt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:49:29 -0500
Received: from mxout1.idt.com ([157.165.5.25]:33088 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1KPNt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:49:27 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5,v3] powerpc/fsl: Document rapidio node binding-information
Date: Wed, 16 Nov 2011 05:49:04 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917D6@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1321099352-21462-5-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5,v3] powerpc/fsl: Document rapidio node binding-information
Thread-Index: AcyhMw2vuwDB6F6rQ0CgVqj8ePEZ3QDM12Wg
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-5-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Li Yang <leoli@freescale.com>, Jin Qing <b24347@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Liu Gang [mailto:Gang.Liu@freescale.com]
> Sent: Saturday, November 12, 2011 7:03 AM
> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> r58472@freescale.com; B11780@freescale.com; r61911@freescale.com; Liu
> Gang; Li Yang; Jin Qing; Kumar Gala
> Subject: [PATCH 5/5,v3] powerpc/fsl: Document rapidio node binding-
> information
> 
> This document is created for powerpc rapidio and rmu nodes in dts
file.
> These nodes can support two rapidio ports and message units. In
> addition,
> It explicates the properties and gives examples about rapidio and rmu
> nodes.
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  .../devicetree/bindings/powerpc/fsl/srio-rmu.txt   |  163
> ++++++++++++++++++++
>  .../devicetree/bindings/powerpc/fsl/srio.txt       |  103
++++++++++++
>  2 files changed, 266 insertions(+), 0 deletions(-)
>  create mode 100644
Documentation/devicetree/bindings/powerpc/fsl/srio-
> rmu.txt
>  create mode 100644
> Documentation/devicetree/bindings/powerpc/fsl/srio.txt
> 

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

