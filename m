Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2LJKbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:31:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52306 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2LJKb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:31:28 -0500
Date: Mon, 10 Dec 2012 19:31:25 +0900 (JST)
Message-Id: <20121210.193125.442743545.hdk@igel.co.jp>
To: laurent.pinchart@ideasonboard.com
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        matsu@igel.co.jp, dhobsong@igel.co.jp
Subject: Re: [PATCH v4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent
From: Hideki EIRAKU <hdk@igel.co.jp>
In-Reply-To: <14014166.3JMiBq7jRA@avalon>
References: <1345112000-22738-1-git-send-email-hdk@igel.co.jp>
	<14014166.3JMiBq7jRA@avalon>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent
Date: Thu, 16 Aug 2012 14:16:32 +0200

> Hi Eiraku-san,
> 
> On Thursday 16 August 2012 19:13:20 Hideki EIRAKU wrote:
>> fb_mmap() implemented in fbmem.c uses smem_start as the physical
>> address of the frame buffer.  In the sh_mobile_lcdc driver, the
>> smem_start is a dma_addr_t that is not a physical address when IOMMU is
>> enabled.  dma_mmap_coherent() maps the address correctly.
>> 
>> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I will push the patch to v3.7 through my tree.

I'd like to use this patch to test IOMMU implementation of Renesas
IPMMU.  But I could not find it in v3.7-rc8.  Could you please tell me if 
this has already been merged somewhere or not?

-- 
Hideki EIRAKU <hdk@igel.co.jp>
