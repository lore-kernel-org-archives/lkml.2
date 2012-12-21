Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2LUBfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:35:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:10495 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2LUBev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:34:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,327,1355126400"; 
   d="scan'208";a="234922345"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "perex@perex.cz" <perex@perex.cz>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Thread-Topic: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Thread-Index: AQHN3rkWqpCwwtvU+06NJ24tHlaA7ZgieMOw
Date: Fri, 21 Dec 2012 01:34:45 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1F48F8@SHSMSX101.ccr.corp.intel.com>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
 <20121219091127.GL4985@opensource.wolfsonmicro.com>
 <27240C0AC20F114CBF8149A2696CBE4A1F3CA7@SHSMSX101.ccr.corp.intel.com>
 <20121220135104.GB4985@opensource.wolfsonmicro.com>
In-Reply-To: <20121220135104.GB4985@opensource.wolfsonmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, December 20, 2012 9:51 PM
> To: Liu, Chuansheng
> Cc: lrg@ti.com; perex@perex.cz; tiwai@suse.de; alsa-devel@alsa-project.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
> 
> On Thu, Dec 20, 2012 at 06:37:26AM +0000, Liu, Chuansheng wrote:
> 
> > Meanwhile, is it useful to add one warning there for that case?
> > After all, in probing, set the bias to _STANDBY even idle_bias_off == 1, and
> calling get_runtime_sync(), it
> > will let the code more obscure. So giving a warning there to indicate the
> driver:
> > it is not suggested that in probing, set the bias to _STANDBY even
> idle_bias_off == 1.
> 
> Probably, send a patch please.  Like I say it is possible to start off
> in _STANDBY providing the driver grabs the runtime PM reference too but
> I can't think of any reason for doing that so the warning seems sensible.
The patch https://lkml.org/lkml/2012/12/20/506 has been sent for giving warning
in that case. Thanks your reviewing.
