Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1HDVzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:55:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:31943 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab1HDVzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:55:37 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1312494934!7863902!14
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
Date: Thu, 4 Aug 2011 16:54:56 -0500
Subject: RE: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
 Core.
Thread-Topic: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
 Core.
Thread-Index: AcxS0iTjjTSXaM2lTpa8wG3wy3yZzAAHppPQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3882B8D51@AUSP01VMBX24.collaborationhost.net>
References: <201108031021.26620.hartleys@visionengravers.com>
 <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
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

On Thursday, August 04, 2011 11:13 AM, Mika Westerberg wrote:
> On Wed, Aug 03, 2011 at 10:21:26AM -0700, H Hartley Sweeten wrote:
>> Convert the ep93xx watchdog driver to using the WatchDog Timer Driver Core.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Wim Van Sebroeck <wim@iguana.be>
>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
>
> BTW, now that the driver uses watchdog core should we also select
> WATCHDOG_CORE in the Kconfig? If it is not enabled we get:
>
> drivers/built-in.o: In function `ep93xx_wdt_init':
> clkdev.c:(.init.text+0x2bd8): undefined reference to
> `watchdog_register_device'
> make: *** [.tmp_vmlinux1] Error 1
>
> Other than that, you can also add my
>
> Reviewed-by: Mika Westerberg <mika.westerberg@iki.fi>
>
> if you like.

Mika,

I just posted a v3 of this patch that includes the Kconfig change to
select WATCHDOG_CORE.  Can you please take a look and possibly test it?

After that I'll add your Tested-by and Reviewed-by tags.

Thanks,
Hartley