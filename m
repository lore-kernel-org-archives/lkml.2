Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1EDNBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:01:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1EDNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:01:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH v4 0/6] staging tidspbridge: iommu migration
Date: Wed, 4 May 2011 15:01:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com> <201105032218.29592.arnd@arndb.de> <BANLkTin7vsfjF+86UrGb7ph0B8TpiXiF0A@mail.gmail.com>
In-Reply-To: <BANLkTin7vsfjF+86UrGb7ph0B8TpiXiF0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041501.16200.arnd@arndb.de>
X-Provags-ID: V02:K0:i2miBqOpu0rR6PvA79FM2ggAm9jBeb87kj7ktfkFQcq
 G8Ve4ThEKHDrD2l2qLKRSFdedIBu6BDOh36IlpNAkvcyrl1lb7
 vpZLQrI0cpXWQxg8/4wloaG6ZoiCuuinGARvJBJwe46iH27phF
 Qp2Rh3/8WBTVxe+kHkonBy+bDdtv9q1i5yr3fthnRQjxwLVrCY
 6GWM0RMzZxcIUCBrD/aXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011, Ramirez Luna, Omar wrote:
> >
> > The code removal in this series looks good, but the move from
> > one proprietary iommu API to another proprietary iommu API
> > seems pointless.
> >
> > It would be much more helpful if you could convert the tidspbridge
> > code to the dma-mapping API, or to the generic iommu API
> > and provide these interfaces from the omap code.
> 
> Yes, I thought removing a bunch of lines from staging might be good.
> I'll check what can be done to use generic iommu or dma-mapping.

Ok, excellent. Have you seen the recent discussions on the
linaro-mm-sig@lists.linaro.org mailing lists? We've been
thinking about how it should be done there, and will continue
the discussions in the upcoming Linaro@UDS meeting in Budapest
next week.

	Arnd
