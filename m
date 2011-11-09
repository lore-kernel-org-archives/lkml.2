Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1KIIuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:50:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1KIIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:50:53 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.63.171]
In-Reply-To: <201109271346.13791.laurent.pinchart@ideasonboard.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-6-git-send-email-ohad@wizery.com> <201109271346.13791.laurent.pinchart@ideasonboard.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 9 Nov 2011 10:50:30 +0200
Message-ID: <CAK=WgbZaZTT=PsrvY8QTypuViknCK=APHogZLg5SjSN3_C=odw@mail.gmail.com>
Subject: Re: [RFC 5/5] iommu/omap: eliminate the public omap_find_iommu_device()
 method
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Sep 27, 2011 at 2:46 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Sunday 25 September 2011 12:58:57 Ohad Ben-Cohen wrote:
>> Eliminate the public omap_find_iommu_device() method, and don't
>> expect clients to provide the omap_iommu handle anymore.
>>
>> Instead, OMAP's iommu driver should now utilize dev_archdata's private
>> iommu extension to be able to access the required iommu information.
>>
>> Update omap3isp appropriately.
>>
>> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>
> For the OMAP3 ISP driver,
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks !

Can you please also ack the 4th patch in this series (that's the part
the makes this fifth patch possible):

https://lkml.org/lkml/2011/9/25/46

I could then ask Tony to Ack it so we could merge this via the iommu tree.

Thanks,
Ohad.
