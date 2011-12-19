Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1LSQ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:57:01 -0500
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:42858 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1LSQ47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:56:59 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Dec 2011 10:56:41 -0600
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Topic: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Index: Acy+by7p22unaTj/Thm/u8aI4XKmvg==
Message-ID: <D482A908-020C-43E0-ADFC-33AE213D7257@boeing.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
 <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
 <20111217092044.GC2833@opensource.wolfsonmicro.com>
In-Reply-To: <20111217092044.GC2833@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2011, at 04:20, Mark Brown wrote:
> On Wed, Dec 14, 2011 at 02:34:37PM -0600, Moffett, Kyle D wrote:
>> On Dec 14, 2011, at 07:02, Mark Brown wrote:
>>> The regulator API in -next has DT bindings.
>> 
>> Based on the description of our hardware, is there a good way that I
>> can wire up gpio-regulator driver to our hardware with just the device
>> tree (and maybe one small board-specific function) to make it shut down
>> each domain in sequence at poweroff time? Otherwise I will just go back
>> to my custom board-specific function for GPIO-twiddling.
> 
> No, it's a very rare use case so there's nothing off the shelf.  But it
> should be straightfoward to write a device driver doing this.

Well, so that's what the "gpio-poweroff" driver I wrote is.  All it does
is hook into the device model and DT and provide various poweroff hooks
that poke GPIOs.

I still don't understand how the regulator API is supposed to help in my
particular case (whole-system poweroff).

Additional advice would be highly appreciated.

Cheers,
Kyle Moffett

