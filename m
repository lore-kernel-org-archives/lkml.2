Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2CWCTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:19:17 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:29364 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2CWCTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:19:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1332469151!1259297!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        Rafal Prylowski <prylowski@metasoft.pl>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Thu, 22 Mar 2012 21:19:10 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0HmlVGFVuPiR9pRw68t72aAyUeXgA9g+tQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
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

On Wednesday, March 21, 2012 12:39 PM, Mika Westerberg wrote:
> On Tue, Mar 20, 2012 at 09:09:26AM +0100, Rafal Prylowski wrote:
>> Implement double buffering for M2M DMA channels.
>> 
>> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
>
> The subject line prefix should probably be 'dmaengine/ep93xx_dma: ' but
> otherwise this looks good.
>
> Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

Mika,

Did you test this patch or just review it?

On my system it doesn't work. I think it has something to do with the
changes to m2m_hw_interrupt but I haven't tracked it down yet.

It looks like what's missing is a:

	edmac->edma->hw_submit(edmac);

But, maybe that's not needed with double buffering?

Regards,
Hartley


