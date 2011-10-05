Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab1JEC5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 22:57:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:45832 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab1JEC5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 22:57:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Date: Tue, 4 Oct 2011 19:57:19 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D635B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20111004185718.a5806a7e.akpm00@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
Thread-Index: AcyDAe3CsC7jB+IVTD6ZRDNX8gWVnQAB6mIA
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com><1317418715-9666-2-git-send-email-alexandre.bounine@idt.com><20110930151544.31875132.akpm00@gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E55202291E8D@CORPEXCH1.na.ads.idt.com><20111004144353.18087914.akpm00@gmail.com><0CE8B6BE3C4AD74AB97D9D29BD24E552022D6319@CORPEXCH1.na.ads.idt.com> <20111004185718.a5806a7e.akpm00@gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm00@gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> > > No, it can be used all over the place:
> drivers/net/irda/w83977af_ir.c,
> > > drivers/scsi/bnx2fc/bnx2fc_tgt.c,
> > > drivers/net/wireless/rt2x00/rt2x00pci.c,
> > > drivers/crypto/amcc/crypto4xx_core.c and many nmore.
> >
> > In this case I will happily use dma_zalloc_coherent() as soon as
> > it is available
> 
> geeze, which of us is more lazy?
> 
> Here we go...
> 
I have an excuse - I am on vacation. Back to the office in almost two
weeks.
WebMail is the only tool for me right now ;) 
