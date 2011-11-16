Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1KPPdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:33:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:57655 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1KPPdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:33:45 -0500
Subject: Re: [PATCH 1/5,v3] fsl-rio: Split rio driver into two parts, RapidIO endpoint and message unit
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917C9@CORPEXCH1.na.ads.idt.com>
Date: Wed, 16 Nov 2011 09:33:24 -0600
Cc: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Lian Minghuan <Minghuan.Lian@freescale.com>
Content-Transfer-Encoding: 7bit
Message-Id: <64766829-647F-49B1-B87C-908F5F528118@kernel.crashing.org>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552024917C9@CORPEXCH1.na.ads.idt.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 16, 2011, at 7:36 AM, Bounine, Alexandre wrote:

>> -----Original Message-----
>> From: Liu Gang [mailto:Gang.Liu@freescale.com]
>> Sent: Saturday, November 12, 2011 7:02 AM
>> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
>> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
>> r58472@freescale.com; B11780@freescale.com; r61911@freescale.com; Liu
>> Gang; Lian Minghuan; Kumar Gala
>> Subject: [PATCH 1/5,v3] fsl-rio: Split rio driver into two parts,
>> RapidIO endpoint and message unit
>> 
>> The Freescale PowerPC RapidIO controller consists of a RapidIO
> endpoint
>> and
>> a RapidIO message unit(RMU). Or use RapidIO message manager(RMan) to
>> replace the RMU in DPAA architecture. Therefore, we should split the
>> code
>> into two function modules according to the hardware architecture. Add
>> new
>> struct for RMU module, and new initialization function to set up RMU
>> module. This policy is very conducive to adding new module like RMan,
>> or
>> adding multi-ports or message units support.
>> 
>> Signed-off-by: Lian Minghuan <Minghuan.Lian@freescale.com>
>> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> arch/powerpc/sysdev/Makefile  |    2 +-
>> arch/powerpc/sysdev/fsl_rio.c | 1152
> +--------------------------------
>> -------
>> arch/powerpc/sysdev/fsl_rio.h |   78 +++
>> arch/powerpc/sysdev/fsl_rmu.c | 1163
>> +++++++++++++++++++++++++++++++++++++++++
>> 4 files changed, 1267 insertions(+), 1128 deletions(-)
>> create mode 100644 arch/powerpc/sysdev/fsl_rio.h
>> create mode 100644 arch/powerpc/sysdev/fsl_rmu.c
>> 
> 
> Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
> 

applied to 'next'

- k

