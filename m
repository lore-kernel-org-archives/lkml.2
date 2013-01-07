Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3AGJUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:20:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51491 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3AGJUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:20:39 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rob@landley.net" <rob@landley.net>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
	tree binding
Thread-Topic: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
	tree binding
Thread-Index: AQHN6nbFhDtsROOE2kyj5Apy+7pkh5g9mvcw
Date: Mon, 7 Jan 2013 09:20:16 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB3690C@DBDE01.ent.ti.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
 <20130104122612.GM4627@opensource.wolfsonmicro.com>
In-Reply-To: <20130104122612.GM4627@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 17:56:12, Mark Brown wrote:
> On Fri, Jan 04, 2013 at 03:24:37PM +0530, Hebbar Gururaja wrote:
> 
> > +		"MIC3L",                "Mic Bias 2V",
> > +		"MIC3R",                "Mic Bias 2V",
> > +		"Mic Bias 2V",          "Mic Jack",
> 
> The CODEC driver biases should be changed over to be supplies, this
> makes the above much more natural - the routing there is a hack for
> older versions of ASoc.  

I will be looking into this now. To speed up the things, do you have any
reference link/implementation which  I can refer to?

I looked at the OMAP implementation but they are following the same (meaning both
DT & non-DT use similar audio map for routing).


> Otherwise this looks fine.

Thanks for the review.

> 


Regards, 
Gururaja
