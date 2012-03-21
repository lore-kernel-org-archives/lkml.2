Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2CURMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:12:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:50681 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2CURMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:12:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1332349916!1134767!13
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Wed, 21 Mar 2012 12:12:11 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0GcMpsb4VmI/h2QWmFCigSvDV7QABE6bYQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
In-Reply-To: <4F683B36.8090101@metasoft.pl>
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

On Tuesday, March 20, 2012 1:09 AM, Rafal Prylowski wrote:
>
> Implement double buffering for M2M DMA channels.
>
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>

Hmm... This isn't working on my ep9307 board...

When the system boots I get stormed with messages:

dma dma1chan0: unknown interrupt!
dma dma1chan0: unknown interrupt!
dma dma1chan0: unknown interrupt!
dma dma1chan1: unknown interrupt!
dma dma1chan1: unknown interrupt!
dma dma1chan1: unknown interrupt!
dma dma1chan0: unknown interrupt!
dma dma1chan0: unknown interrupt!
dma dma1chan1: unknown interrupt!

Note, I have use_dma set for the ep93xx_spi driver and am using mmc_spi.

Also note, without your patch I also get a couple messages:

dma dma1chan1: got interrupt while active list is empty

But, the mmc card is working fine. I haven't tracked down why I get these
yet. Mika, any ideas?

Regards,
Hartley

