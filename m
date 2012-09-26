Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2IZJsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:48:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46943 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2IZJsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:37 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Thread-Topic: [PATCH v2] arm/dts: AM33XX: Add SPI device tree data
Thread-Index: AQHNlWGG1yNOfoKWN0C6qlsopGsCgpeUnoOQ
Date: Wed, 26 Sep 2012 09:47:19 +0000
Deferred-Delivery: Wed, 26 Sep 2012 09:47:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9A927A@DBDE01.ent.ti.com>
References: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1347946228-25874-1-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tue, Sep 18, 2012 at 11:00:28, Philip, Avinash wrote:
> Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> as the driver) is reused from OMAP4.
> 	
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Tested-by: Matt Porter <mporter@ti.com>


I haven't received any comments till now for this patch. 
Do you have any comments for this patch? 

With this patch SPI is working on AM335x SoC in PIO mode.

If no comments, can you pull this patch for 3.7?

Thanks
Avinash
