Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2IQBU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:20:27 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:52458
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab2IQBUW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:20:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(z1039oz1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdhbe9i1155h)
From: Chen Peter-B29397 <B29397@freescale.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Zhao Richard-B20223 <B20223@freescale.com>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "marex@denx.de" <marex@denx.de>
Subject: RE: [RFC PATCH] drivers: phy: add generic PHY framework
Thread-Topic: [RFC PATCH] drivers: phy: add generic PHY framework
Thread-Index: AQHNknBkSgyuwBX0D0+wZXIOeXdiZpeNv1rw
Date: Mon, 17 Sep 2012 01:20:19 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649803C82462@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
In-Reply-To: <1347623899-14485-1-git-send-email-kishon@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.66]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> The PHY framework provides a set of API's for the PHY drivers to
> create/remove a PHY and the PHY users to obtain a reference to the PHY
> using or without using phandle. If the PHY users has to obtain a
> reference to
> the PHY without using phandle, the platform specfic intialization code
> (say
> from board file) should have already called phy_bind with the binding
> information. The binding information consists of phy's device name, phy
> user device name and an index. The index is used when the same phy user
> binds to mulitple phys.
> 

What's an example of "the same phy user binds to multiple phys"?
I only remembered that Felipe said there are two phy users for one single phy at 
omap5 that is both usb3 and sata uses the same phy.


 


