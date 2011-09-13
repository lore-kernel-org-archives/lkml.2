Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1IML0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:26:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47413 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1IML0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:26:20 -0400
Message-ID: <4E6F3DD8.2010206@monstr.eu>
Date: Tue, 13 Sep 2011 13:26:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli.billauer@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] microblaze: Added DMA sync operations
References: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com> <1315770188-17550-2-git-send-email-eli.billauer@gmail.com>
In-Reply-To: <1315770188-17550-2-git-send-email-eli.billauer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Added support gor dma_direct_sync_single_for_*() and dma_direct_sync_sg_for_*()
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
> ---
>  arch/microblaze/kernel/dma.c |   60 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)

Applied.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
