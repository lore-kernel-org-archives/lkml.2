Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0KKNky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:40:54 -0500
Received: from mxout1.idt.com ([157.165.5.25]:50233 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0KKNkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:40:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Date: Thu, 11 Nov 2010 05:40:04 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201538C1E@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <A530CF80-F6B6-40BE-A465-18884B887432@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Thread-Index: AcuBm68ofkNTKNOfSKSemajoC5lnQgACaPug
References: <1288777018-24259-1-git-send-email-b21989@freescale.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55201538B08@CORPEXCH1.na.ads.idt.com> <9FCE46230501DF4D9461B9ACC152FD7104DDA26D@zmy16exm20.fsl.freescale.net> <A530CF80-F6B6-40BE-A465-18884B887432@kernel.crashing.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Kumar Gala" <galak@kernel.crashing.org>,
        "Xie Shaohui-B21989" <B21989@freescale.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Li Yang-R58472" <R58472@freescale.com>,
        "Gala Kumar-B11780" <B11780@freescale.com>,
        "Zang Roy-R61911" <R61911@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@kernel.crashing.org> wrote:
> > [Xie Shaohui-B21989] Hi Alex, seems your suggestion is some kind of
> > conflict with Kumar, you can have a look at
> > http://patchwork.ozlabs.org/patch/67774/
> 
> I think Alex's comment is the fact we ignore the 'return' value in the
machine_check_e500 case.

Yes, this one and plus the fact that Mchk exception messages are printed
even if it was handled successfully (by RIO handler). Messages are
printed in both: e500 and e500mc handlers.

Alex.
  
