Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1DFQDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:03:51 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:56271
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab1DFQDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:03:49 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 6 Apr 2011 11:03:35 -0500
From: Scott Wood <scottwood@freescale.com>
To: Justin Mattock <justinmattock@gmail.com>
CC: <trivial@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Harninder Rai <harninder.rai@freescale.com>
Subject: Re: [RFC 2/5]arch:powerpc:sysdev:Makefile Remove unused config in
 the Makefile.
Message-ID: <20110406110335.0f2d5f4c@schlenkerla.am.freescale.net>
In-Reply-To: <BANLkTi=5A1P-WAFvCyjbT7RVva9K9d=gQQ@mail.gmail.com>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
	<1302022702-24541-2-git-send-email-justinmattock@gmail.com>
	<20110405131504.1d182da4@schlenkerla.am.freescale.net>
	<BANLkTi=5A1P-WAFvCyjbT7RVva9K9d=gQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 08:07:58 -0700
Justin Mattock <justinmattock@gmail.com> wrote:

> ahh.. so the:  fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o is still in use
> even though FSL_85XX_CACHE_SRAM is not really used, but really is used!!
> 
> but might be wrong with this.

More like there are plans to use it, or possibly out-of-tree users.  We
should prod people a bit to submit the driver patches that use this before
we just yank it out.

-Scott

