Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab1INFL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:11:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48559 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1INFLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:11:55 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <1315949582.2687.204.camel@shinybook.infradead.org>
References: <1315942288-17297-1-git-send-email-ohad@wizery.com>
 <1315942288-17297-5-git-send-email-ohad@wizery.com> <1315949582.2687.204.camel@shinybook.infradead.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 14 Sep 2011 08:11:34 +0300
Message-ID: <CAK=WgbbVTFb3vh7CA+teA4Un9-BBaAVO5m-rq2V6CMKv0++YFg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] iommu/intel: announce supported page sizes
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:32 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2011-09-13 at 22:31 +0300, Ohad Ben-Cohen wrote:
>> + * Traditionally the IOMMU core just handed us the mappings directly,
>> + * after making sure the size is an order of a 4KB page and that the
>> + * mapping has natural alignment.
>> + *
>> + * To retain this behavior, we currently advertise that we support
>> + * all page sizes that are an order of 4KB.
>
> This is wrong. We do not support 4000-byte pages. We only support
> 4096-byte pages. 4KiB, not 4kB.
>
> Please fix.

Sure thing; I'll s/KB/KiB throughout the patch set.

Do I have your ACK otherwise ?

Thanks,
Ohad.
