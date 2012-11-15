Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768538Ab2KORLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:11:34 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48995 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768440Ab2KORLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:11:33 -0500
Message-ID: <1352999486.2532.18.camel@lorien2>
Subject: Re: [PATCH linux-next] ARM64: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Catalin Marinas <catalin.marinas@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 10:11:26 -0700
In-Reply-To: <20121105164618.GF17864@arm.com>
References: <1351205220.6851.3.camel@lorien2>
	 <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
	 <1351264983.2712.14.camel@lorien2> <1351871933.2721.10.camel@lorien2>
	 <20121105164618.GF17864@arm.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 16:46 +0000, Catalin Marinas wrote:
> On Fri, Nov 02, 2012 at 03:58:53PM +0000, Shuah Khan wrote:
> > On Fri, 2012-10-26 at 09:23 -0600, Shuah Khan wrote:
> > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > debug_dma_unmap() interface when it checks for mapping error checked
> > > status. Without this patch, device driver failed to check map error
> > > warning is generated. 
> > > 
> > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > Do you want this patch going through linux-next or the ARM64 tree? Let
> > me know your preference.
> 
> I think it can go together with your other patches since I can't tell
> when you'll push the debug_dma_mapping_error() implementation.
> 

Marek,

This one is for ARM64 and ARM tree has already been fixed.

-- Shuah

