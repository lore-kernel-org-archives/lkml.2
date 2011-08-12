Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1HLNvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:51:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41340 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1HLNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110812145818.00cde392@laptop.anywhere.org>
References: <20110812145818.00cde392@laptop.anywhere.org>
Date: Fri, 12 Aug 2011 23:51:47 +1000
Message-ID: <CAPM=9tzwYHgbmKUuPsrW_4nrKOQ5m+7N0JV-kMpOv43yVh-49A@mail.gmail.com>
Subject: Re: Kernel panic with intel_iommu=on
From: Dave Airlie <airlied@gmail.com>
To: "Udo A. Steinberg" <udo@hypervisor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:58 PM, Udo A. Steinberg <udo@hypervisor.org> wrote:
> Hello,
>
> After upgrading from firefox 5.0.1 to 6.0b5, my machine locks up hard, the
> moment firefox is started under Linux 3.0 with Intel IOMMU enabled.
>
> With intel_iommu=off, everything works fine. Likewise, when going back to
> firefox 5.0.1, everything works fine. I've managed to capture the following
> kernel output via the serial console.

Does intel_iommu=igfx_off work as well?

I've been seeing a few of these with Ironlake chipsets, the reason
firefox does it is probably because it causes the 3D driver to be
used.

Dave.
