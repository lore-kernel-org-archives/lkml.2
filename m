Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2JLDvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:51:47 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42391 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab2JLDvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:51:46 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432I4015Izz1202h1d1ah1d2ahzzz32i2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1155h)
Message-ID: <1350017479.22202.2.camel@dinh-ubuntu>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
From: Dinh Nguyen <dinguyen@altera.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Artem Bityutskiy <dedekind1@gmail.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 11 Oct 2012 22:51:19 -0600
In-Reply-To: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
References: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 2012-10-12 at 11:14 +1100, Stephen Rothwell wrote:
> Hi Artem,
> 
> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "denali_init" [drivers/mtd/nand/denali_pci.ko] undefined!
> ERROR: "denali_remove" [drivers/mtd/nand/denali_pci.ko] undefined!
> 
> Probably caused by commit 305b1ee29c8e ("mtd: denali: split the generic
> driver and PCI layer").
> 
> I have used the l2-mtd tree from next-20121011 for today.

Sorry about that. I just sent a patch to fix this. Please disregard the
first email, I forgot to include Artem in the email.

Thanks,
Dinh



