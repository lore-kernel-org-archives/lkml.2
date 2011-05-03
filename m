Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1ECUSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:18:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1ECUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:18:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [PATCH v4 0/6] staging tidspbridge: iommu migration
Date: Tue, 3 May 2011 22:18:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        "Ohad Ben-Cohen" <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105032218.29592.arnd@arndb.de>
X-Provags-ID: V02:K0:lWi3dWf9r3wpZYAfMZ/H17lN6fJmw60/W62HtwrFLB2
 9AmfzwoVAm2xR+1pZP941fpqkhPtc9JJG8FRWcy9gxxJF0S2k+
 BQVU2bfQ0U9kpyWI2mZ6sfImqVBpwTsoHlk3pBAPdIP9hOIyB1
 aT652x5byQmCciTfp7TmzeNVzGAe3AWmAcOnBU5dix3LbQqxdR
 PT8b0sK2p6p6Yg1hU+KFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011 17:31:46 Omar Ramirez Luna wrote:
> Rework and rebase of the previous set of patches for iommu migration[1].
> 
> Reorganized the patches to avoid several iterations to change the same code.
> 
> Patches were tested with an OMAP3630 board, with both, basic samples and
> gst-dsp; these are dependant on patch:
>         "OMAP: iovmm: fix SW flags passed by user"[2].

The code removal in this series looks good, but the move from
one proprietary iommu API to another proprietary iommu API
seems pointless.

It would be much more helpful if you could convert the tidspbridge
code to the dma-mapping API, or to the generic iommu API
and provide these interfaces from the omap code.

	Arnd
