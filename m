Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2K0Mx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:53:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54754 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2K0Mx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:53:26 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tony@atomide.com" <tony@atomide.com>, "Girdwood, Liam" <lrg@ti.com>,
        "perex@perex.cz" <perex@perex.cz>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>
Subject: RE: [PATCH 2/2] ASoC: Davinci: machine: Add device tree binding
Thread-Topic: [PATCH 2/2] ASoC: Davinci: machine: Add device tree binding
Thread-Index: AQHNyGaRGoEnLR/QDkiU6/YbCdqFLJf7rRaAgAH9QRA=
Date: Tue, 27 Nov 2012 12:53:00 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EADA52C@DBDE01.ent.ti.com>
References: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
 <1353557099-21599-3-git-send-email-gururaja.hebbar@ti.com>
 <20121126115619.GF9411@opensource.wolfsonmicro.com>
In-Reply-To: <20121126115619.GF9411@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 17:26:19, Mark Brown wrote:
> On Thu, Nov 22, 2012 at 09:34:59AM +0530, Hebbar, Gururaja wrote:
> 
> > +- dai-data		: A list of DAI data used by SOC code to register
> > +			  DAI, Codecs platform.
> > +			  The string index "should" be as shown below.
> > +dai-data =
> > +"<DAI Name>", 		"<DAI Stream Name>",
> > +"<CODEC DAI Name>",	"<true if evm_aic3x_init is required, else false>",
> > +"<evm ops required (evm_ops or evm_spdif_ops)>";
> 
> This continues to have the same issue as with previous versions, this is
> all Linux internals (especially the evm_aic3x_init thing) not a
> description of the hardware, there's not enough information to allow
> someone to work out what the bindings for their system should be.

Last time when you gave the review comments for this, I misunderstood it for
missing/incomplete documentation, which is why I added more details to the
binding document in V3. 

Now that I have understood correctly, I will be removing references to 
linux/software parts in the DT and will handle it internally in the driver
code. 

Kindly accept my apologies in this regard.

> 
> Do not post *ANY* further versions that have this evm_aic3x_init stuff
> in them, it's very annoying that you keep on ignoring this feedback.

Sure will remove the reference and repost it soon.

Thanks for all the review and guidance.

> 


Regards, 
Gururaja
