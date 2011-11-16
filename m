Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1KPNlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:41:23 -0500
Received: from mxout1.idt.com ([157.165.5.25]:32776 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab1KPNlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:41:22 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/5, v3] fsl-rio: Add two ports and rapidio message units support
Date: Wed, 16 Nov 2011 05:39:11 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917CC@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1321099352-21462-2-git-send-email-Gang.Liu@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/5, v3] fsl-rio: Add two ports and rapidio message units support
Thread-Index: AcyhM03i3fGsmafBTGesrT592UtnkQDMYANQ
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-2-git-send-email-Gang.Liu@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: Jin Qing <b24347@freescale.com>, <r58472@freescale.com>,
        <r61911@freescale.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <B11780@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linuxppc-dev-bounces+alexandre.bounine=idt.com@lists.ozlabs.org
> [mailto:linuxppc-dev-
> bounces+alexandre.bounine=idt.com@lists.ozlabs.org] On Behalf Of Liu
> Gang
> Sent: Saturday, November 12, 2011 7:02 AM
> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
> Cc: Jin Qing; r58472@freescale.com; r61911@freescale.com; linux-
> kernel@vger.kernel.org; Liu Gang; akpm@linux-foundation.org;
> B11780@freescale.com
> Subject: [PATCH 2/5, v3] fsl-rio: Add two ports and rapidio message
> units support
> 
> Usually, freescale rapidio endpoint can support one or two 1x or 4X
> LP-Serial link interfaces, and rapidio message transactions can be
> implemented by two message units. This adds the support of two
> rapidio ports and initializes message unit 0 and message unit 1. And
> these ports and message units can work simultaneously.
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |  391 +++++++++++++++++++++-----------
>  arch/powerpc/sysdev/fsl_rio.h |   75 ++++++-
>  arch/powerpc/sysdev/fsl_rmu.c |  502
++++++++++++++++++---------------
> --------
>  3 files changed, 545 insertions(+), 423 deletions(-)
> 

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>


