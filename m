Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab2GQLjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:39:11 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4508
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab2GQLjI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:39:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Zhao Chenhui-B35336 <B35336@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH v7 2/5] powerpc/85xx: add HOTPLUG_CPU support
Thread-Topic: [PATCH v7 2/5] powerpc/85xx: add HOTPLUG_CPU support
Thread-Index: AQHNWQVoThvQ6RzhcEef9iu6oEJhTZcnhA0AgAXrQEA=
Date: Tue, 17 Jul 2012 11:39:04 +0000
Message-ID: <7AA2FF042C086D469F577FA6723434DA071060@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
 <1341310879-5468-2-git-send-email-chenhui.zhao@freescale.com>
 <0090811B-107A-4496-ADF1-DD07081BF6B9@kernel.crashing.org>
In-Reply-To: <0090811B-107A-4496-ADF1-DD07081BF6B9@kernel.crashing.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Friday, July 13, 2012 8:15 PM
> To: Zhao Chenhui-B35336
> Cc: linuxppc-dev@lists.ozlabs.org; Wood Scott-B07421; linux-kernel@vger.kernel.org; Li Yang-R58472
> Subject: Re: [PATCH v7 2/5] powerpc/85xx: add HOTPLUG_CPU support
> 
> 
> On Jul 3, 2012, at 5:21 AM, Zhao Chenhui wrote:
> 
> > From: Li Yang <leoli@freescale.com>
> >
> > Add support to disable and re-enable individual cores at runtime
> > on MPC85xx/QorIQ SMP machines. Currently support e500v1/e500v2 core.
> >
> > MPC85xx machines use ePAPR spin-table in boot page for CPU kick-off.
> > This patch uses the boot page from bootloader to boot core at runtime.
> > It supports 32-bit and 36-bit physical address.
> >
> > Add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE in kick_cpu().
> 
> Shouldn't the generic_setup_cpu_up() be a separate patch, and refactor smp_generic_kick_cpu() to use
> it.
> 
> Also, we should pull the conversion of the spintable from #defines to struct into a separate patch
> before this one.
> 

Ok. I will split this patch.

-Chenhui

