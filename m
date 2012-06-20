Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2FTEqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:46:10 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:34345 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab2FTEqG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:46:06 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: David Miller <davem@davemloft.net>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "federico.vaga@gmail.com" <federico.vaga@gmail.com>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
Date: Wed, 20 Jun 2012 12:45:46 +0800
Subject: RE: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: Ac1Onn8kQxSUwitASwiVeI3uPf+0VAAAJ7bw
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au>
	<D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
 <20120619.213703.513466167861199217.davem@davemloft.net>
In-Reply-To: <20120619.213703.513466167861199217.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, June 20, 2012 10:07 AM
> To: Bhupesh SHARMA
> Cc: sfr@canb.auug.org.au; netdev@vger.kernel.org; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org;
> federico.vaga@gmail.com; Giancarlo ASNAGHI; wg@grandegger.com;
> mkl@pengutronix.de
> Subject: Re: linux-next: build failure after merge of the net-next tree
> 
> From: Bhupesh SHARMA <bhupesh.sharma@st.com>
> Date: Wed, 20 Jun 2012 12:27:11 +0800
> 
> > clk_get/clk_put* variants are usually used by ARM platforms.
> > Protecting their calls under macro 'CONFIG_HAVE_CLK' should solve the
> problem.
> 
> No, we don't pepper foo.c files with crappy ifdefs.

So, whether adding a check in Kconfig for HAVE_CLK be a proper solution ?
But that will limit the compilation of this driver for only platforms which are ARM based.

One may need to support this driver on x86 like platforms also..

Regards,
Bhupesh
