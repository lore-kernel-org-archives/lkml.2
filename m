Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2LUN7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:59:31 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:43627 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab2LUN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:59:25 -0500
Message-ID: <1356098364.1490.114.camel@tellur>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Dec 2012 14:59:24 +0100
In-Reply-To: <50D46AE4.8020308@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
	 <1356097818.1490.109.camel@tellur> <50D46AE4.8020308@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 21.12.2012, 15:57 +0200 schrieb Terje Bergström:
> On 21.12.2012 15:50, Lucas Stach wrote:
> > This has to be resolved before merging. Personally I'm in favour of
> > keeping reg access patterns close to what is done in other parts of the
> > kernel.
> 
> I haven't so far received comments from too many people, so that's why I
> left it as is.
> 
> >>  * Uses still CMA helpers. IOMMU support will replace CMA with host1x
> >>    specific allocator.
> > 
> > I really want the allocator issue resolved before talking about merging
> > those patches. Proper IOMMU support will require a bit of rework of the
> > current upstream IOMMU API, so it will still be a bit out.
> > 
> > But if you don't mind I'll try to implement the host1x allocator over
> > the holidays and provide an incremental patch.
> 
> Do you mean host1x CMA allocator using dma mapping API? That'd be great
> if you could help out. I've just tried to concentrate on getting ok for
> base essentials before doing any extra work.
> 
Yes, exactly that.

I'll provide comments to the other patches when I find time to do so.
Digging in the code might help with this.

Regards,
Lucas

