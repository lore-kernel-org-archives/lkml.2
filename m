Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1J1IJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:09:11 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:41443 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1J1IJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:09:07 -0400
From: Barry Song <Barry.Song@csr.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Topic: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
Thread-Index: AQHMjUNMpdQ62Jn2VkSdRYTOA7OjuZWPYX+AgAGqasD//6JKAIAAlPjggAAy06A=
Date: Fri, 28 Oct 2011 08:08:27 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E98419FAC0@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
	 <1319703535.20054.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E98419F7FF@SHAASIEXM01.ASIA.ROOT.PRI>
 <1319774982.20054.228.camel@vkoul-udesk3> 
Accept-Language: zh-CN, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.36.58]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9S89LNX027377

> -----Original Message-----
> From: Barry Song
> Sent: 2011å¹´10æœˆ28æ—¥ 13:04
> To: 'Vinod Koul'
> Cc: Arnd Bergmann; Jassi Brar; Linus Walleij; linux-kernel@vger.kernel.org;
> DL-SHA-WorkGroupLinux; Rongjun Ying; linux-arm-kernel@lists.infradead.org
> Subject: RE: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
> 
> > -----Original Message-----
> > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > Sent: 2011å¹´10æœˆ28æ—¥ 12:10
> > To: Barry Song
> > Cc: Arnd Bergmann; Jassi Brar; Linus Walleij; linux-kernel@vger.kernel.org;
> > DL-SHA-WorkGroupLinux; Rongjun Ying; linux-arm-kernel@lists.infradead.org
> > Subject: RE: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
> >
> > On Fri, 2011-10-28 at 01:49 +0000, Barry Song wrote:
> > > > Also, Please ensure you send patches which compile with ZERO warnings:
> > > > drivers/dma/sirf-dma.c: In function 'sirfsoc_dma_probe':
> > > > drivers/dma/sirf-dma.c:616: warning: assignment from incompatible
> > pointer
> > > > type
> > > > drivers/dma/sirf-dma.c:617: warning: assignment from incompatible
> > pointer
> > > > type
> > > > which comes from the fact that your prep_interleaved_dma does not have
> > > > last argument of flags.
> > > > On the second one you have not rebased to patch from Jassi which I
> > > > applied after converting direction stuff.
> > >
> > >
> > [pls wrap 80chars within paragraphs, i have reformatted below)
> > > I rebased to both yours and Jassi by my merging manually. I remember
> > > you have changed the last param of device_prep_dma_cyclic from
> > > dma_data_direction to dma_transfer_direction. After checking the tree
> > > interleaved_dma @ git://git.infradead.org/users/vkoul/slave-dma.git,
> > > it doesn't. then make another compiling warning in
> > > sirfsoc_dma_prep_cyclic(). so I'll still use dma_data_direction in
> > > sirfsoc_dma_prep_cyclic().
> > Yes for cyclic, I have missed to fix that. I will push the fixed version
> 
> Ok. note my v5 is still using dma_data_direction. You might take care too :-)

Vinod, as I have acked interleaved dma API explicitly before, could you pls add: 
Acked-by: Barry Song <Baohua.Song@csr.com>
in the commit of " DMAEngine: Define interleaved transfer request api" in your tree too. I didn't find it after I fetch your tree :-)

> 
> > now
> >
> > --
> > ~Vinod
-barry



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
