Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1CCHtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:49:23 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:54233 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1CCHtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:49:21 -0500
X-Spam-Processed: srv201.gdsys.de, Thu, 03 Mar 2011 08:49:17 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Subject: RE: (WARNING!!! PGP with incorrect signature) Re: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
Date: Thu, 3 Mar 2011 08:49:13 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE6B@SRV101.gdsys.de>
Importance: normal
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: (WARNING!!! PGP with incorrect signature) Re: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
thread-index: AcvZCGVRcrT/JR8HTFyv30apyFE0wgAblIqA
References: <20110302181651.GA24054@pengutronix.de>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Wolfram Sang" <w.sang@pengutronix.de>,
        "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, <guenter.roeck@ericsson.com>,
        <lm-sensors@lm-sensors.org>, <rdunlap@xenotime.net>,
        <linux-doc@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110303074920Z
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.178; VDF: 7.11.4.47; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> Still, there is a new property defined which _always_ needs
> 
> a) CCing devicetree-discuss (get_maintainer helps here)
> b) Documentation in Documentation/devicetree/bindings
> 
> because it needs to be a lot more stable than platform_data.

Jean, should I supply a v5 with Documentation or should I supply a
separate patch?

> (I already lost the original mail, so I sadly can't forward it)

I have forwarded it to devicetree-discuss.
 
> Regards,
> 
>    Wolfram

Cheers
Dirk


