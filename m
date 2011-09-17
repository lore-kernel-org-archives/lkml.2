Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1IQTWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 15:22:14 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:42110 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1IQTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 15:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net>
References: <4E734467.3040703@bootc.net>
	<1316256305.24257.25.camel@shinybook.infradead.org>
	<AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
	<3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net>
Date: Sat, 17 Sep 2011 12:22:12 -0700
Message-ID: <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
From: adam radford <aradford@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 7:29 AM, Chris Boot <bootc@bootc.net> wrote:
> On 17 Sep 2011, at 12:57, Chris Boot wrote:
>> On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
>>> I suppose it's vaguely possible that we're leaking them in such a way
>>> that they remain on the rbtree, perhaps if the deferred unmap is never
>>> actually happening... but I think it's a whole lot more likely that the
>>> PCI driver is just never bothering to unmap the pages it maps.

If you think 3w-9xxx is not unmapping pages it maps, please re-run with
CONFIG_PCI_DMA_DEBUG=y

-Adam
