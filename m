Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2GYOLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:11:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49980 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2GYOLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:11:41 -0400
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
Subject: RE: [PATCH v2 6/6] arm/dts: am33xx rtc node
Thread-Topic: [PATCH v2 6/6] arm/dts: am33xx rtc node
Thread-Index: AQHNaiyGJuGQat7MTEqFmhFrCStuC5c5fpEAgACJOIA=
Date: Wed, 25 Jul 2012 14:09:58 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E9AD8B1@DBDE01.ent.ti.com>
References: <cover.1343191280.git.afzal@ti.com>
 <d16976055462214af276d7242faa2bc6e621fd44.1343191280.git.afzal@ti.com>
 <500FD698.30906@mvista.com>
In-Reply-To: <500FD698.30906@mvista.com>
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

On Wed, Jul 25, 2012 at 16:50:56, Sergei Shtylyov wrote:

> > +		rtc@44e3e000 {
> 
>     Address postfix in the node name without "reg" property?

As per [1], "The unit-address is included if the node describes
a device with an address".

Here even though reg property is not present, as via hwmod
(see below) it is getting address, isn't it better to have it

> 
> > +			compatible = "ti,da830-rtc";
> > +			ti,hwmods = "rtc";

Regards
Afzal


[1] http://devicetree.org/Device_Tree_Usage
