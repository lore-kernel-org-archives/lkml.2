Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1IKQCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 12:02:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48484 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1IKQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 12:02:29 -0400
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
Date: Sun, 11 Sep 2011 21:32:46 +0530
Message-ID: <1315756966.2246.3.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:18 +0800, Barry Song wrote:
> 2011/9/9 Vinod Koul <vkoul@infradead.org>:
> > On Thu, 2011-09-08 at 10:55 +0530, Jassi Brar wrote:
> >> On Thu, Sep 8, 2011 at 8:47 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> Jassi prefer to use a transfer type instead of a control command.
> though we will not really change the interleaved setting for every
> transfer(it is more possible for one device, we will not change the
> xlen/ylen/dma_width setting in the whole life period), i do believe
> the transfer type is enough flexible for my possible applications to
> change xlen, ylen and dma_width in different transfers.
Is this usually the assumption or yours is a special case, how about
your's Jassi? 

-- 
~Vinod Koul
Intel Corp.

