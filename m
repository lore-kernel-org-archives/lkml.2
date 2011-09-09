Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab1IIQVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:21:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1IIQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:21:02 -0400
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vkoul@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: vinod.koul@intel.com, Jassi Brar <jassisinghbrar@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAGsJ_4xv9+=+=2b=i47P5V5sOQH-GyTMaESwbeHxu439Vx1gLA@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	 <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	 <1315518378.6638.2.camel@vkoul-mobl4>
	 <CAGsJ_4xv9+=+=2b=i47P5V5sOQH-GyTMaESwbeHxu439Vx1gLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Fri, 09 Sep 2011 21:51:22 +0530
Message-ID: <1315585282.30522.1.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:18 +0800, Barry Song wrote:
> 2011/9/9 Vinod Koul <vkoul@infradead.org>:
> > Looks like Jassi got a user for his proposed API. I am not sure whats
> > going on with TI folks, they never showed up here @LPC.
> 
> yes, i can definitely be an user of Jassi's new generic api. it seems
> the api is just there for dma in 2d.
> 
> Jassi prefer to use a transfer type instead of a control command.
> though we will not really change the interleaved setting for every
> transfer(it is more possible for one device, we will not change the
> xlen/ylen/dma_width setting in the whole life period), i do believe
> the transfer type is enough flexible for my possible applications to
> change xlen, ylen and dma_width in different transfers.
> 
> as we know, interleaved DMA can also be used for audio driver. for
> some audio controllers, if there are n channels, it can't tranfer the
> whole audio frame to sound card by one dma channel, and it needs to
> tranfer every channel by separate dma. typically, we can define this
> kind of xfer to skip other n-1 channel.
> 
> Jassi, you might think my reply as an ACK to "[PATCH] DMAEngine:
> Define generic transfer request api".
Great, can you two redo patch along with this driver as user of new
API :)

-- 
~Vinod Koul
Intel Corp.

