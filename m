Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1JLGad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:30:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1JLGa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <1318400368.1546.372.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	<CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	<20111003161349.GB28287@flint.arm.linux.org.uk>
	<CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	<CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	<1317966346.1573.2252.camel@vkoul-udesk3>
	<CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	<1317997177.1573.2275.camel@vkoul-udesk3>
	<CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
	<1318229592.1573.2298.camel@vkoul-udesk3>
	<CAJe_ZhcWUjdh-LGuAaDAbSYNYrV5dzsrkpCGCeYo6y38pNac4g@mail.gmail.com>
	<1318238296.1546.3.camel@vkoul-udesk3>
	<CAJe_ZheDWAeisyOxFVmhWgZCi5qx8QL1_L+YttFrzWxSHyceug@mail.gmail.com>
	<1318243501.1546.12.camel@vkoul-udesk3>
	<CAJe_Zhd0xVULcEd2t5DwofmjPNrxOi3bUjMVDRF5N4+47kUiJw@mail.gmail.com>
	<1318262559.1546.31.camel@vkoul-udesk3>
	<CAJe_ZhcYiu1ZAWBGww2tysP5K_QwmoRNtfMZ9t2erRXhHY5W0A@mail.gmail.com>
	<CAGsJ_4zzN1erduhV_hwWpPgTQ-YFowoPpmC_CKaT_C2=63OtZg@mail.gmail.com>
	<1318400368.1546.372.camel@vkoul-udesk3>
Date: Wed, 12 Oct 2011 12:00:27 +0530
Message-ID: <CAJe_Zhc5_zW3_mH4zwW7jiVNziZZF0OzzmHz93J5GBu=OGqtvg@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Barry Song <21cnbao@gmail.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2011 11:49, Vinod Koul <vinod.koul@intel.com> wrote:
>
> @Jassi: I have started doing this change for dmaengine and dmacs, and I
> took the liberty to name this enum as dma_transfer_direction, hope you
> are okay with that
>
OK. Thanks.
