Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2KEQq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:46:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37866 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab2KEQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:46:56 -0500
Date: Mon, 5 Nov 2012 16:46:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "nico@linaro.org" <nico@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH linux-next] ARM64: dma-mapping: support
 debug_dma_mapping_error
Message-ID: <20121105164618.GF17864@arm.com>
References: <1351205220.6851.3.camel@lorien2>
 <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
 <1351264983.2712.14.camel@lorien2>
 <1351871933.2721.10.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351871933.2721.10.camel@lorien2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:58:53PM +0000, Shuah Khan wrote:
> On Fri, 2012-10-26 at 09:23 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated. 
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Do you want this patch going through linux-next or the ARM64 tree? Let
> me know your preference.

I think it can go together with your other patches since I can't tell
when you'll push the debug_dma_mapping_error() implementation.

-- 
Catalin
