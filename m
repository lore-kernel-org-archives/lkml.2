Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2CGMx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:53:58 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:36175
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab2CGMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:53:57 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH] powerpc/srio: Fix the compile errors when building
	with 64bit
From: Liu Gang <Gang.Liu@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <r61911@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <B946A444-73EC-4A70-AA7E-31FAF31FFF13@kernel.crashing.org>
References: <1330672127-22172-1-git-send-email-Gang.Liu@freescale.com>
	 <6BFCD6C7-7675-4A99-9C4C-4E86FA5642A4@kernel.crashing.org>
	 <1330957222.23420.136.camel@10.ap.freescale.net>
	 <B946A444-73EC-4A70-AA7E-31FAF31FFF13@kernel.crashing.org>
Content-Type: text/plain
Date: Wed, 7 Mar 2012 20:52:21 +0800
Message-ID: <1331124741.23420.140.camel@10.ap.freescale.net>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kumar,

On Tue, 2012-03-06 at 11:46 -0600, Kumar Gala wrote:
> How about a struct instead:
> 
> struct rmu_dmsg {
> 	u16	dummy;
> 	u16	tid;
> 	u16	sid;
> 	u16	info;
> };
> 
> 	struct rmu_dmsg *dmsg = fsl_dbell->dbell_ring.virt + (in_be32(&fsl_dbell->dbell_regs->dqdpar) & 0xfff);
> 
> Than you can git rid of the DBELL_* macros.

Yes, this can really git rid of the DBELL_* macros and some other code.
I'll update the patch based on your comments.
Thanks a lot.

Liu Gang


