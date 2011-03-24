Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab1CXTsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:48:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:48232
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933847Ab1CXTr5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:47:57 -0400
X-SpamScore: -21
X-BigFish: VPS-21(z2005kz542N1432N4015L9371Pzz1202hzz8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: multiple definition of `show_mem'
Date: Thu, 24 Mar 2011 13:47:39 -0600
In-Reply-To: <4D8B6140.4020300@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: multiple definition of `show_mem'
Thread-Index: AcvqN1d3c94LGL1eREu3kqsUNCS+kQAJDpYw
References: <4D8B6140.4020300@pengutronix.de>
From: John Linn <John.Linn@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <kernel@pengutronix.de>, David Rientjes <rientjes@google.com>
X-OriginalArrivalTime: 24 Mar 2011 19:47:42.0028 (UTC) FILETIME=[568EC8C0:01CBEA5C]
X-RCIS-Action: ALLOW
Message-ID: <b22a2fa5-f819-4576-8898-8532874e2594@VA3EHSMHS036.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org
[mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Marc Kleine-Budde
> Sent: Thursday, March 24, 2011 9:21 AM
> To: LKML
> Cc: linux-arm-kernel; kernel@pengutronix.de; David Rientjes
> Subject: multiple definition of `show_mem'
> 
> Hello,
> 
> current mainline (v2.6.38-7210-gb81a618) on ARM/mxs has the following
build failure:
> 
> > lib/lib.a(show_mem.o): In function `show_mem':
> > .../linux-2.6/lib/show_mem.c:67: multiple definition of `show_mem'
> > arch/arm/mm/built-in.o:.../linux-2.6/arch/arm/mm/init.c:82: first
> > defined here
> > make: *** [vmlinux.o] Error 1

I'm seeing the same error for my patches for the new Xilinx ARM
platform.

> 
> After reverting these patches the kernel compiles...
> 
> cbf978bfb12d7deca97d7333f65eda0381a072de oom: suppress nodes that are
not allowed from meminfo on page
> alloc failure
> 29423e77c06cee7d4e335ef4a7cbd949da978c91 oom: suppress show_mem() for
many nodes in irq context on
> page alloc failure ddd588b5dd55f14320379961e47683db4e4c1d90 oom:
suppress nodes that are not allowed
> from meminfo on oom kill
> 
> No time to boot the kernel, though.

I did the same reverts and the kernel built and booted fine.

Thanks,
John

> 
> cheers, MArc
> 
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


