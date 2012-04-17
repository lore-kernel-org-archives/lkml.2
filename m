Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2DQPsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:48:23 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51001 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2DQPqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:46:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1334677589!3411659!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Rafal Prylowski <prylowski@metasoft.pl>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Tue, 17 Apr 2012 10:46:28 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0caex4X0qtK6OFStW/8+oWZlDE2AARxXCw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A3E66@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
 <20120410172853.GA25697@mwesterb-mobl>
 <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
 <4F853053.7040800@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F00206987A3BFE@AUSP01VMBX24.collaborationhost.net>
 <4F8D189B.3010100@metasoft.pl>
In-Reply-To: <4F8D189B.3010100@metasoft.pl>
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

On Tuesday, April 17, 2012 12:16 AM, Rafal Prylowski wrote:
> On 2012-04-16 20:59, H Hartley Sweeten wrote:
>> It appears your patch is causing an interrupt storm on my system.
>> 
>
> Could you please apply the following patch on top of double buffering
> patch? I would like to know the state of dma channel when you get
> that interrupt storm.

Rafal,

Here's the output:

mmc_spi spi0.1: SD/MMC host mmc0, no poweroff
M2M: 20c3
M2M: 20c3
M2M: 21c3
M2M: 21c3
M2M: 21c3
M2M: 21c3
M2M: 21c3
M2M: 21c3

The "M2M: 21c3" keeps getting output until the system is turned off.

Regards,
Hartley
