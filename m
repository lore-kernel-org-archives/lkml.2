Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2H0SCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:02:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54913 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2H0SCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:02:51 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: RE: [PATCH] ARM: AM33XX: clock: Add dcan clock aliases for
 device-tree
Thread-Topic: [PATCH] ARM: AM33XX: clock: Add dcan clock aliases for
 device-tree
Thread-Index: AQHNhDurjKQbZY/bOUaqH5mz8nRcmZdti8MAgABnbhA=
Date: Mon, 27 Aug 2012 18:02:35 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EA99396@DBDE01.ent.ti.com>
References: <1346061842-28714-1-git-send-email-hvaibhav@ti.com>
 <alpine.DEB.2.00.1208271717420.26953@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1208271717420.26953@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 22:50:12, Paul Walmsley wrote:
> Hi
> 
> On Mon, 27 Aug 2012, Vaibhav Hiremath wrote:
> 
> > Currently, the device names for the dcan module follows the
> > format "dcan.X", where 'X' is the dcan instance number.
> > On other side, driver may request for clock with/without con_id
> > and dev_id, and it is expected that platform should respect this
> > request and return the requested clock handle.
> > 
> > Now, when using device tree, the format of the device name created
> > by OF layer is different, "<reg-address>.<device-name>",
> > assuming that the device-tree "reg" property is specified.
> > This causes the look-up failure for clock node in dcan driver
> > 
> > To fix this add new dcan clock alias for using device-tree.
> 
> Is the dcan driver present in v3.6-rc kernels?  

Multiple versions have been submitted already, I have validated using them.
Irrespective of this, it is independent change and required for the driver.

Thanks,
Vaibhav

