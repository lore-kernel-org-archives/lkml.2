Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2GBCHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:07:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38882 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab2GBCHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:07:15 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: David Miller <davem@davemloft.net>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
Subject: RE: [PATCH] ethernet: add export.h in davinci_cpdma.c
Thread-Topic: [PATCH] ethernet: add export.h in davinci_cpdma.c
Thread-Index: Ac1X8Funclewraz+TkKfQvom2CLpBv//fo6A//9xUrA=
Date: Mon, 2 Jul 2012 02:07:04 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCAEF@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FCAAB@DQHE02.ent.ti.com>
 <20120701.183333.353465166541062775.davem@davemloft.net>
In-Reply-To: <20120701.183333.353465166541062775.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -19,6 +19,7 @@
> >  #include <linux/err.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/io.h>
> > +#include <linux/export.h>
> 
> You aren't generating this patch against current sources, otherwise
> you'd see that linux/module.h is included in this driver and therefore
> the problem you ran into is not possible.

Oops ! This patch was generated based on the latest linux-omap tree, but similar code was already patched in linux-next tree.
Thanks for the notice.

Best Regards,
Milo -
