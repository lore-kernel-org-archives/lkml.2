Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1KPPdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:33:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:57659 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1KPPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:33:48 -0500
Subject: Re: [PATCH 2/5, v3] fsl-rio: Add two ports and rapidio message units support
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552024917CC@CORPEXCH1.na.ads.idt.com>
Date: Wed, 16 Nov 2011 09:33:15 -0600
Cc: Liu Gang <Gang.Liu@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        Jin Qing <b24347@freescale.com>, r58472@freescale.com,
        linux-kernel@vger.kernel.org, r61911@freescale.com,
        akpm@linux-foundation.org, B11780@freescale.com
Content-Transfer-Encoding: 7bit
Message-Id: <D97116A8-B63C-4A38-B637-EDCD3129A078@kernel.crashing.org>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-2-git-send-email-Gang.Liu@freescale.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552024917CC@CORPEXCH1.na.ads.idt.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 16, 2011, at 7:39 AM, Bounine, Alexandre wrote:

>> -----Original Message-----
>> From: linuxppc-dev-bounces+alexandre.bounine=idt.com@lists.ozlabs.org
>> [mailto:linuxppc-dev-
>> bounces+alexandre.bounine=idt.com@lists.ozlabs.org] On Behalf Of Liu
>> Gang
>> Sent: Saturday, November 12, 2011 7:02 AM
>> To: linuxppc-dev@lists.ozlabs.org; Bounine, Alexandre
>> Cc: Jin Qing; r58472@freescale.com; r61911@freescale.com; linux-
>> kernel@vger.kernel.org; Liu Gang; akpm@linux-foundation.org;
>> B11780@freescale.com
>> Subject: [PATCH 2/5, v3] fsl-rio: Add two ports and rapidio message
>> units support
>> 
>> Usually, freescale rapidio endpoint can support one or two 1x or 4X
>> LP-Serial link interfaces, and rapidio message transactions can be
>> implemented by two message units. This adds the support of two
>> rapidio ports and initializes message unit 0 and message unit 1. And
>> these ports and message units can work simultaneously.
>> 
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> Signed-off-by: Jin Qing <b24347@freescale.com>
>> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> arch/powerpc/sysdev/fsl_rio.c |  391 +++++++++++++++++++++-----------
>> arch/powerpc/sysdev/fsl_rio.h |   75 ++++++-
>> arch/powerpc/sysdev/fsl_rmu.c |  502
> ++++++++++++++++++---------------
>> --------
>> 3 files changed, 545 insertions(+), 423 deletions(-)
>> 
> 
> Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
> 

applied to 'next'

- k
