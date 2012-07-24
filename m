Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2GXMF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:05:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33422 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab2GXMFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:05:24 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Nori, Sekhar" <nsekhar@ti.com>, "Hilman, Kevin" <khilman@ti.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: RE: [PATCH 2/6] ARM: davinci: remove rtc kicker release
Thread-Topic: [PATCH 2/6] ARM: davinci: remove rtc kicker release
Thread-Index: AQHNaNkCMXmm6CaP6EaR8T5kRUa4eJc37DAAgABm2KA=
Date: Tue, 24 Jul 2012 12:04:30 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E9AD19E@DBDE01.ent.ti.com>
References: <cover.1343046707.git.afzal@ti.com>
 <f9e348c8cb7402b27b1a5633b06620266e369641.1343046707.git.afzal@ti.com>
 <500E82D4.9090702@mvista.com>
In-Reply-To: <500E82D4.9090702@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Tue, Jul 24, 2012 at 16:41:16, Sergei Shtylyov wrote:

> >   static struct platform_device da8xx_rtc_device = {
> > -	.name           = "omap_rtc",
> > +	.name           = "am1808-rtc",
> 
>     Why not "da8xx-rtc". Kick registers exist startting with 
> DA830/OMAP-L137/AM1707, not only on AM1808.

I would prefer to keep da830-rtc, even though it is not strictly
a requirement; "da830-rtc" could be used for DT case too (as in
DT, wild card compatibles are not recommended), hence allowing
us to have a uniform name for DT & non-DT case.

Regards
Afzal
