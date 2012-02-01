Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2BAHJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:09:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41799 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2BAHJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:09:20 -0500
Date: Tue, 31 Jan 2012 23:09:18 -0800
From: Olof Johansson <olof@lixom.net>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] arm: tegra: dma: not required to move requestor when
 stopping.
Message-ID: <20120201070918.GA7399@quad.lixom.net>
References: <1327392649-27605-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81E5F@HQMAIL01.nvidia.com>
 <4F27CA58.2020809@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27CA58.2020809@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 04:32:48PM +0530, Laxman Dewangan wrote:
> On Wednesday 25 January 2012 02:27 AM, Stephen Warren wrote:
> >Laxman Dewangan wrote at Tuesday, January 24, 2012 1:11 AM:
> >>It is not require to move the requestor of dma to INVALID
> >>option before stopping dma.
> >>
> >>Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> >Acked-by: Stephen Warren<swarren@nvidia.com>
> >Tested-by: Stephen Warren<swarren@nvidia.com>
> >
> >I know that Laxman has checked with the HW engineers, and they see no
> >reason to do this. I was originally worried about hung FIFOs preventing
> >an in-progress DMA from completely without the removed code, but according
> >to HW, that isn't a concern.
> >
> Olaf,
> Can it be applied if it is OK to you?

Yep, applied.


-Olof
