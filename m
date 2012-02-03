Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2BCQgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:36:54 -0500
Received: from mxout1.idt.com ([157.165.5.25]:47504 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab2BCQgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:36:53 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 06/11] nand/gpmi: add context parameter to prep_slave_sg calls
Date: Fri, 3 Feb 2012 08:35:59 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552028726F4@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <201202022313.33164.marek.vasut@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 06/11] nand/gpmi: add context parameter to prep_slave_sg calls
Thread-Index: Aczh+OFKHcIqOzguQde+LgelaLgvtAAl9d2A
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-7-git-send-email-alexandre.bounine@idt.com> <201202022313.33164.marek.vasut@gmail.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Marek Vasut <marek.vasut@gmail.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 5:14 PM, Marek Vasut wrote:
> 
> > Fixups for calls affected by adding the new context parameter to
DMA_SLAVE
> > and DMA_CYCLIC interfaces.
> 
> Thanks!
Please note that this depends on changes introduced by patch [01/11]
from the set.
The changes to DMA_SLAVE interface have not been accepted yet.
I probably had to pack all changes together as it was suggested in
comments to
other parts of this patchset.  

> >
... skip ....

