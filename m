Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2BCQxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:53:50 -0500
Received: from mxout1.idt.com ([157.165.5.25]:48400 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2BCQxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:53:49 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 05/11] mmc/host: add context parameter for DMA_SLAVE and DMA_CYCLIC
Date: Fri, 3 Feb 2012 08:52:07 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520287270D@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4F2BA6C0.10100@stericsson.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 05/11] mmc/host: add context parameter for DMA_SLAVE and DMA_CYCLIC
Thread-Index: AcziVULAqn3vAeWWTmmjtd5Rpz4HXAAPaumA
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-6-git-send-email-alexandre.bounine@idt.com> <4F2BA6C0.10100@stericsson.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per FORLIN <per.forlin@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 4:20 AM, Ulf Hansson wrote:
> 
> Alexandre Bounine wrote:
> > Fixups for calls affected by adding the new context parameter to
DMA_SLAVE
> > and DMA_CYCLIC interfaces.
... skip ...
> >
> 
> I have not been following the patches for changing the API. But does
> that mean that before this patch we are getting compile
> errors/warnings?

No. This is a new API change in [01/11]. This change was in discussion
some time ago.
Now I am getting back to it. See https://lkml.org/lkml/2012/2/2/461 for
more details.

> Is so, the complete API change should have been included in this patch
> as well, right?
> 
Yes, this patch better to be submitted as a single patch combined with
the proposed API change. Sorry for inconvenience.
If these API changes will be approved I will resubmit these changes as
one patch.

Alex.


