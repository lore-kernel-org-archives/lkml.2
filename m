Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1GMWPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:15:22 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23432 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1GMWPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:15:21 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1310595319!14265081!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "thierry.nolf.barco@gmail.com" <thierry.nolf.barco@gmail.com>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Date: Wed, 13 Jul 2011 17:15:17 -0500
Subject: RE: [PATCH] new helper to define common struct resource constructs
Thread-Topic: [PATCH] new helper to define common struct resource constructs
Thread-Index: AcxBpm+ccmBkjrXKTFyxydf910AD0AAAixog
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F383E058E9@AUSP01VMBX24.collaborationhost.net>
References: <14C4E31473AF7E4B98176CB73615181C19FBD3@039-SN1MPN1-006.039d.mgd.msft.net>
	<201107121529.17611.arnd@arndb.de>
	<20110713141849.b8cbf675.akpm@linux-foundation.org>
 <201107132342.18648.arnd@arndb.de>
In-Reply-To: <201107132342.18648.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 13, 2011 2:42 PM, Arnd Bergmann wrote:
> On Wednesday 13 July 2011 23:18:49 Andrew Morton wrote:
>>> On Monday 11 July 2011, Uwe Kleine-K__nig wrote:
>>>> resource definitions that just define start, end and flags = IORESOURCE_MEM
>>>> or IORESOURCE_IRQ (with start=end) are quite common. So introduce a shortcut
>>>> for them. Also make available a macro to specify named resources of both
>>>> types which are less common.
>>>> 
>>>> Signed-off-by: Uwe Kleine-K____nig <u.kleine-koenig@pengutronix.de>
>>> 
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>> 
>>> What do others think, is this worthwhile?
>>> Should we also define macros for IORESOURCE_IO and IORESOURCE_DMA?
>>> 
>>
>> It would help if we could see some usage examples (ie: sample
>> conversions), to get a better idea of the value of this.
>
> Uwe posted a patch '[PATCH] ARM: mxc: use new helpers to define
> common struct resource entries' that converts one ARM platform to use
> it, with reasonable outcome:
>
> 26 files changed, 72 insertions(+), 308 deletions(-)

ep93xx doesn't have that many but converting it's core.c gives:

 1 files changed, 19 insertions(+), 93 deletions(-)

Regards,
Hartley
