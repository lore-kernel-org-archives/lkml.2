Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1JBQfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:35:16 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47270 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1JBQfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:35:13 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.135.251]
In-Reply-To: <1317566760-25681-11-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-11-git-send-email-arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 2 Oct 2011 18:34:52 +0200
Message-ID: <CAK=WgbY-1VU5tJNxaJmP+8xqxV+XHjFeV=hjmxpZNuQJdKg=BQ@mail.gmail.com>
Subject: Re: [PATCH 10/30] ARM: omap/iommu: always provide iommu debug code
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The iommu module on omap contains a few functions that are
> only used by the debug module. These are however only there
> when the debug code is built as a module. Since it is possible
> to build the debug code into the kernel, the functions should
> also be provided for the built-in case.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/plat-omap/iommu.c |    2 +-

Thanks, Arnd.

The driver has moved to drivers/iommu/ and changed a bit, but this
patch is still relevant.

The merge conflict will be trivial to resolve, but if you prefer, we
can prevent it by taking this patch via the iommu tree.

Thanks,
Ohad.
