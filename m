Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1FHKdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:33:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47651 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1FHKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:33:31 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <1307524659.4771.12.camel@i7.infradead.org>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <1307522062-19273-5-git-send-email-ohad@wizery.com> <1307524659.4771.12.camel@i7.infradead.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 8 Jun 2011 13:33:10 +0300
Message-ID: <BANLkTi=eRmd4h3+StGCR_-uVKo5F9fyd7g@mail.gmail.com>
Subject: Re: [PATCH 4/4] x86: intel-iommu: move to drivers/iommu/
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:17 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> At least iova.o wants to go with it. That's one of the parts that is a
> candidate for harmonisation across IOMMU implementations, either by
> removing it or by having others use it too. It's how we allocate virtual
> I/O address space.
>
> I suspect the interrupt remapping support may well want to move with it
> too. It's no more out-of-place in drivers/iommu than it is in
> drivers/pci. And then you can certainly move dmar.o too.

Sounds good, thanks.

I'll wait a bit to see if there're more comments, and then re-send this one
