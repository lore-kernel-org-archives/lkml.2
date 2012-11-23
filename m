Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2KWKhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:37:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56752 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2KWKgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:36:20 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v4 09/11] ARM: dts: AM33XX: Add PWMSS device tree nodes
Thread-Topic: [PATCH v4 09/11] ARM: dts: AM33XX: Add PWMSS device tree nodes
Thread-Index: AQHNx+pMHfCrohGssEC2FjJr30hCbpf1/yOAgAEyn6A=
Date: Fri, 23 Nov 2012 10:35:01 +0000
Deferred-Delivery: Fri, 23 Nov 2012 10:35:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EE9A9@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-10-git-send-email-avinashphilip@ti.com>
 <20121122210857.GH16716@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121122210857.GH16716@avionic-0098.adnet.avionic-design.de>
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

On Fri, Nov 23, 2012 at 02:38:57, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 06:41:06PM +0530, Philip, Avinash wrote:
> > Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
> > AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
> > adding necessary properties like pwm-cells, base reg & set disabled as
> > status.
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > ---
> > Changes since v2:
> > 	- ranges property populated to handle child devices address range
> > 
> > :100644 100644 20a3f29... 4393161... M	arch/arm/boot/dts/am33xx.dtsi
> >  arch/arm/boot/dts/am33xx.dtsi |   84 +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 84 insertions(+), 0 deletions(-)
> 
> Looks good to me,

Thanks
Avinash

> 
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> 

