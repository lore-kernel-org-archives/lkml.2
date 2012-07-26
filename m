Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2GZLUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:20:39 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51703 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2GZLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:20:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH v2 4/4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available
Date: Thu, 26 Jul 2012 13:20:44 +0200
Message-ID: <1820152.JumtPU1V17@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1343301191-26001-5-git-send-email-hdk@igel.co.jp>
References: <1343301191-26001-1-git-send-email-hdk@igel.co.jp> <1343301191-26001-5-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiraku-san,

On Thursday 26 July 2012 20:13:11 Hideki EIRAKU wrote:
> fb_mmap() implemented in fbmem.c uses smem_start as the physical
> address of the frame buffer.  In the sh_mobile_lcdc driver, the
> smem_start is a dma_addr_t that is not a physical address when IOMMU is
> enabled.  dma_mmap_coherent() maps the address correctly.  It is
> available on ARM platforms.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

