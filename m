Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996Ab1INE5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 00:57:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:19123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1INE5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 00:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48184554"
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <Baohua.Song@csr.com>,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <CACRpkdYkuhhR8yNMK1cENan9WX5Fv7o_0qSN3_c3VJQwrvzgjg@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <201109081819.30035.arnd@arndb.de>
	 <CAKnu2Mpnjec-hvfbT0zH1P2mGZKNwTQYgDLGHWUXLmGGQB0_ow@mail.gmail.com>
	 <2264116.VTHb2BIH5a@wuerfel> <1315517883.6638.1.camel@vkoul-mobl4>
	 <CACRpkdYkuhhR8yNMK1cENan9WX5Fv7o_0qSN3_c3VJQwrvzgjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 10:24:17 +0530
Message-ID: <1315976057.26251.461.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-11 at 23:27 +0200, Linus Walleij wrote:
> On Thu, Sep 8, 2011 at 11:38 PM, Vinod Koul <vkoul@infradead.org> wrote:
> >
> > Linus W, any progress on that patches you posted??
> 
> I haven't written any, and I felt the whole issue was pretty inflamed
> too so I felt bad about it and avoided to think about it even since
> I have no real problem with this in my current setups.
> 
> Currently there is a strong coupling between platforms and filter
> functions and I can live with it in the systems I use since they have
> just one DMAC and need only one filter function per device,
> that is specified in platform data for the device. This would likely
> also work for the SiRFprimaII if it has only a single DMAC.
> The people facing an immediate issue with this are IIRC the
> Samsung S5Ps.
> 
> If you think this is in need of solving soon and want me to propose
> patches for channel mapping to devices using the approach used in
> clkdev and regulator APIs to create an attributed mapping table
> using struct device * or its string representations, I can
> try it out of course, but if it gets flamy I will just back off again.
Please try at my request. I really would like this problem to be solved.

What we want is API which solves filter function issues (we should be
able to completely do away after proper mapping). Making a simple to
understand/code/maintain scheme which is platform independent.


-- 
~Vinod

