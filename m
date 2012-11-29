Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2K2HxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:53:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35176 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2K2HxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:53:03 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.24.217]
In-Reply-To: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 29 Nov 2012 09:52:41 +0200
Message-ID: <CAK=Wgba1eu1+NFsS1+xcO4rq+steWi9-HW6RgySAU3FX1XsEeg@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] OMAP: iommu: hwmod, reset handling and runtime PM
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@arm.linux.org.uk>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 3:05 AM, Omar Ramirez Luna <omar.luna@linaro.org> wrote:
> These patches are needed for remoteproc to work on OMAP4.
>
> Introduced iommu hwmod support for OMAP3 (iva, isp) and
> OMAP4 (ipu, dsp), along with the corresponding runtime PM
> and routines to deassert reset lines, enable/disable clocks
> and configure sysc registers.

I tested the entire series with remoteproc/rpmsg on OMAP4 and it looks good.

Since this is super needed, and have already been going on for quite a
while, I'd really like to see this go in. We could then incrementally
deal with any outstanding comment or issue that might show up.

Joerg, can you please take it (or at least its first four patches) ?
We have Tony's ack for the mach-omap2 parts.

Tested-by: Ohad Ben-Cohen <ohad@wizery.com>

Thanks,
Ohad.
