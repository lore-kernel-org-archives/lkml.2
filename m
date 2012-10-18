Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2JROkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:40:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38627 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab2JROke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:40:34 -0400
From: "Porter, Matt" <mporter@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH v2 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Topic: [PATCH v2 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Index: AQHNrG6CyTzX50BI7U2Age1UjgQ9vpe/d/oA
Date: Thu, 18 Oct 2012 14:40:28 +0000
Message-ID: <3098B0AA-7032-4A49-8D4E-EF1D726ED85A@ti.com>
References: <1349991229-32107-1-git-send-email-mporter@ti.com>
 <20121017135116.GU14199@opensource.wolfsonmicro.com>
In-Reply-To: <20121017135116.GU14199@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9AA8773DB5A8E409437D571059D4D4F@owa.mail.ti.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 17, 2012, at 9:51 AM, Mark Brown wrote:

> On Thu, Oct 11, 2012 at 05:33:47PM -0400, Matt Porter wrote:
> 
>> This series converts davinci ASoC to use genalloc and enables
>> that support on DA850. It applies to mainline on top of the
>> uio_pruss/genalloc series [1] which allows DaVinci to provide
>> a gen_pool via pdata for driver use.
> 
> I tried to apply these patches but patch 2 doesn't apply against
> v3.7-rc1 I guess due to the series you mention.  What's the plan for
> merging that series?  It'd also be good to get Daniel's patch squashed
> in.

I will ping Hans about the uio_pruss driver portion. Sekhar was waiting
on a ack for that before applying all of the supporting genalloc patches
for mach-davinci/

-Matt

