Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2JROlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:41:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2JROlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:41:49 -0400
From: "Porter, Matt" <mporter@ti.com>
To: Daniel Mack <zonque@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v2 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Topic: [PATCH v2 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Index: AQHNrG6CyTzX50BI7U2Age1UjgQ9vpe93CmAgAGcLYA=
Date: Thu, 18 Oct 2012 14:41:43 +0000
Message-ID: <97AD915E-BA5A-4003-8ECC-0798C88222B1@ti.com>
References: <1349991229-32107-1-git-send-email-mporter@ti.com>
 <20121017135116.GU14199@opensource.wolfsonmicro.com>
 <507EBB65.2090100@gmail.com>
In-Reply-To: <507EBB65.2090100@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11A483E24BB65E4FAA5E274EFD77CA76@owa.mail.ti.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 17, 2012, at 10:06 AM, Daniel Mack wrote:

> On 17.10.2012 15:51, Mark Brown wrote:
>> On Thu, Oct 11, 2012 at 05:33:47PM -0400, Matt Porter wrote:
>> 
>>> This series converts davinci ASoC to use genalloc and enables
>>> that support on DA850. It applies to mainline on top of the
>>> uio_pruss/genalloc series [1] which allows DaVinci to provide
>>> a gen_pool via pdata for driver use.
>> 
>> I tried to apply these patches but patch 2 doesn't apply against
>> v3.7-rc1 I guess due to the series you mention.  What's the plan for
>> merging that series?  It'd also be good to get Daniel's patch squashed
>> in.
> 
> I'll resend the rebased patches from my 3.7-rc1 development branch with
> my patch squashed into 1/2. Matt, hope you're ok with that?

Yes, thanks.

-Matt
