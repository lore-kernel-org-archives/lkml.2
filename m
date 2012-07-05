Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2GERgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:36:13 -0400
Received: from void.printf.net ([89.145.121.20]:42197 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2GERgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:36:11 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/9 v3] mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare to shdma conversion
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	<1336576161-27082-4-git-send-email-g.liakhovetski@gmx.de>
Date: Thu, 05 Jul 2012 13:35:56 -0400
In-Reply-To: <1336576161-27082-4-git-send-email-g.liakhovetski@gmx.de>
	(Guennadi Liakhovetski's message of "Wed, 9 May 2012 17:09:15 +0200")
Message-ID: <87a9zexg8z.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 09 2012, Guennadi Liakhovetski wrote:
> Now that all users have been updated to use the embedded in struct
> sh_mmcif_plat_data DMA slave IDs, struct sh_mmcif_dma is no longer needed
> and can be removed. This also makes preparation to the shdma base library
> conversion easier.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Chris Ball <cjb@laptop.org>

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
