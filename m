Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2CHGdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:33:10 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:10312
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600Ab2CHGdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:33:06 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: RE: [PATCH v2] powerpc/srio: Fix the compile errors when building
	with 64bit
From: Liu Gang <Gang.Liu@freescale.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <r58472@freescale.com>, <linux-kernel@vger.kernel.org>,
        <r61911@freescale.com>, <paul.gortmaker@windriver.com>,
        <akpm@linux-foundation.org>, Shaohui Xie <Shaohui.Xie@freescale.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E91@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E91@saturn3.aculab.com>
Content-Type: text/plain
Date: Thu, 8 Mar 2012 14:31:17 +0800
Message-ID: <1331188278.23420.157.camel@10.ap.freescale.net>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David,

On Wed, 2012-03-07 at 13:18 +0000, David Laight wrote:  
> >  	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d
> buffer " \
> > -		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer,
> len);
> > +		 "%8.8lx len %8.8zx\n", rdev->destid, mbox,
> > +		(unsigned long)buffer, len);
> 
> Should 'buffer' be printed with %p ??

Yes, printing with "%p" can get rid of the cast, although they have the
same print results.

Thanks a lot.

Liu Gang


