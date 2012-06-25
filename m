Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2FYM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:28:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49571 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2FYM23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:28:29 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH 1/3] regulator: tps65217: Add device tree support
Thread-Topic: [PATCH 1/3] regulator: tps65217: Add device tree support
Thread-Index: AQHNUsrAz1h7PZCi6EarEaW8TIzwHJcKlcAAgABdUCA=
Date: Mon, 25 Jun 2012 12:28:15 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9DFA80@DBDE01.ent.ti.com>
References: <1340625878-32336-1-git-send-email-anilkumar@ti.com>
 <1340625878-32336-2-git-send-email-anilkumar@ti.com>
 <20120625121220.GA30406@opensource.wolfsonmicro.com>
In-Reply-To: <20120625121220.GA30406@opensource.wolfsonmicro.com>
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

Hi Mark,

Thanks for quick reply.

On Mon, Jun 25, 2012 at 17:42:20, Mark Brown wrote:
> On Mon, Jun 25, 2012 at 05:34:36PM +0530, AnilKumar Ch wrote:
> > This commit adds device tree support for tps65217 pmic. And usage
> > details are added to device tree documentation.
> > 
> > Driver is tested by using kernel module with regulator set and get
> > APIs.
> 
> This needs to be updated for the patches Laxman recently posted for the
> regulator-compatible property (which are currently blocked on review
> from the ST Ericcsson guys but I'll probably apply them in the next
> couple of days if I don't hear back from them).
> 

In that case, I will resubmit the patches once "regulator-compatible
property" patches are pushed to "linux-next".

Thanks
AnilKumar

