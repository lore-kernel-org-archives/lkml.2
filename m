Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2BCQnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:43:35 -0500
Received: from mxout1.idt.com ([157.165.5.25]:47885 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab2BCQne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:43:34 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 11/11] sound/soc: add context parameter to prep_slave_sg and prep_dma_cyclic calls
Date: Fri, 3 Feb 2012 08:41:54 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552028726FD@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20120202222158.GA3112@opensource.wolfsonmicro.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 11/11] sound/soc: add context parameter to prep_slave_sg and prep_dma_cyclic calls
Thread-Index: Aczh+lgFvFdntEQ7QCCmzXlH07C8OQAl88Fg
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-12-git-send-email-alexandre.bounine@idt.com> <20120202222158.GA3112@opensource.wolfsonmicro.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Ralf Baechle <ralf@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 5:22 PM, Mark Brown wrote:
> 
> On Thu, Feb 02, 2012 at 04:32:21PM -0500, Alexandre Bounine wrote:
> > Fixups for calls affected by adding the new context parameter to
DMA_SLAVE
> > and DMA_CYCLIC interfaces.
> 
> This really ought to be squashed in with the original commit both to
> avoid build breaks in bisection and to let people review what this
> parameter does.

Agree. Will pack it together to resubmit if it will be decided to go
ahead with this change.
This will make quite large patch but it will help to track it properly.

