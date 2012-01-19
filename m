Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2ASDsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:48:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50504 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab2ASDsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:48:39 -0500
Date: Wed, 18 Jan 2012 19:48:42 -0800
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH V1] ARM: tegra: Pause DMA when reading transfer count
Message-ID: <20120119034842.GA7145@quad.lixom.net>
References: <1326175511-28642-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A77E@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A77E@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:48:26PM -0800, Stephen Warren wrote:
> Laxman Dewangan wrote at Monday, January 09, 2012 11:05 PM:
> > In order to read an accurate channel transfer count
> > from the APB DMA engine, the DMA controller must be
> > paused first.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> (Audio playback on Harmony booted using device tree works fine in my
> brief testing)

Thanks, applied.


-Olof
