Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2LJWxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:53:34 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37488 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LJWxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:53:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        matsu@igel.co.jp, dhobsong@igel.co.jp
Subject: Re: [PATCH v4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent
Date: Mon, 10 Dec 2012 23:54:45 +0100
Message-ID: <1441080.TGoVcIhooK@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121210.193125.442743545.hdk@igel.co.jp>
References: <1345112000-22738-1-git-send-email-hdk@igel.co.jp> <14014166.3JMiBq7jRA@avalon> <20121210.193125.442743545.hdk@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiraku-san,

On Monday 10 December 2012 19:31:25 Hideki EIRAKU wrote:
> On Thu, 16 Aug 2012 14:16:32 +0200 Laurent Pinchart wrote:
> > On Thursday 16 August 2012 19:13:20 Hideki EIRAKU wrote:
> >> fb_mmap() implemented in fbmem.c uses smem_start as the physical
> >> address of the frame buffer.  In the sh_mobile_lcdc driver, the
> >> smem_start is a dma_addr_t that is not a physical address when IOMMU is
> >> enabled.  dma_mmap_coherent() maps the address correctly.
> >> 
> >> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I will push the patch to v3.7 through my tree.
> 
> I'd like to use this patch to test IOMMU implementation of Renesas
> IPMMU.  But I could not find it in v3.7-rc8.  Could you please tell me if
> this has already been merged somewhere or not?

I'm afraid the patch got delayed to v3.8, sorry about that. I've sent a pull 
request for v3.8, the patch is currently in linux-next 
(bf10a53765b4435a5349a92a5a51753902ed86f1) and will be merged during the next 
merge window (which should open in the very near future).

-- 
Regards,

Laurent Pinchart

