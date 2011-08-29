Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1H2K7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 06:59:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1H2K70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 06:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110829101550.GT1923@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com> <20110829101550.GT1923@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Aug 2011 13:59:05 +0300
X-Google-Sender-Auth: zTUcEiJ4DFpsEMDjL4eQY_5jECA
Message-ID: <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:15 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Isn't the abstraction that the drivers use the dma-api? There should be
> an implementation that doesn't require the iommu-api for such devices,
> no?

Before we boot a remote processor device we often need to map it to
some (specific) bus addresses (e.g. to allow the processor access to
certain peripheral devices), and we're doing it directly with the
IOMMU API.

Do you think this kind of functionality should be added to the DMA API as well ?

IIRC, it was suggested awhile ago but you supported using the IOMMU
API directly in this case.

Thanks,
Ohad.
