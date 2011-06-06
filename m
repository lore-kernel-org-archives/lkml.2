Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1FFPPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:15:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53093 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1FFPPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:15:51 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.65.238]
In-Reply-To: <20110606100950.GC30762@amd.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <20110606100950.GC30762@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Jun 2011 18:15:30 +0300
Message-ID: <BANLkTi=i2s-Ujiy4qn_XQv+9dMjUC9R66A@mail.gmail.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Mon, Jun 6, 2011 at 1:09 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> The IOMMU-API already supports multiple page-sizes. See the
> 'order'-parameter of the map/unmap functions.

This is insufficient; users need somehow to tell what page sizes are
supported by the underlying hardware (we can't assume host page-sizes,
and we want to use bigger pages whenever possible, to relax the TLB
pressure).

>>   Further generalizing of iovmm strongly depends on our broader plans for
>>   providing a generic virtual memory manager and allocation framework
>>   (which, as discussed, should be separated from a specific mapper).
>
> The generic vmm for DMA is called DMA-API :) Any reason for not using
> that (those reasons should be fixed)?

This is definitely something we will look into (dspbridge will need it
too, not only omap3isp).

Thanks,
Ohad.
