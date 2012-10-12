Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab2JLQoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:44:21 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50323
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759817Ab2JLQoT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:44:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3hd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441hbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 0/2] dmaengine: Fix compillation issues in
 device_prep_dma_cyclic()
Thread-Topic: [alsa-devel] [PATCH 0/2] dmaengine: Fix compillation issues in
 device_prep_dma_cyclic()
Thread-Index: AQHNqJjQ2Z50xvm5ZUOdAgaV2qGyJQ==
Date: Fri, 12 Oct 2012 16:44:15 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7080FEAB8@039-SN2MPN1-023.039d.mgd.msft.net>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
	<1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <A827A0995B731A449EDC094624CD43F9@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 2:58 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> PS: I did build tested the series on ARM (OMAP), x86_32, x86_64 but not for ppc
> for sure.

For the record, patch #1 fixes the build break on PowerPC.  Thanks.

-- 
Timur Tabi
Linux kernel developer at Freescale
