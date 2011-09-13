Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1IMLbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:31:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1IMLbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:31:46 -0400
Message-ID: <4E6F3F1F.8030300@monstr.eu>
Date: Tue, 13 Sep 2011 13:31:43 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli.billauer@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] microblaze: Refinements on cache flushes and invalidations
 (dma.c)
References: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com> <1315770188-17550-3-git-send-email-eli.billauer@gmail.com>
In-Reply-To: <1315770188-17550-3-git-send-email-eli.billauer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Mapping and unmapping methods' cache syncronization calls were refined to
> avoid unnecessary synchronizations of the cache. Flushing of the cache is
> now made even when mapping memory as DMA_FROM_DEVICE, so that a possible
> dirty cache lines don't get flushed later, and overwrite data written by
> device.
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
> ---
>  arch/microblaze/kernel/dma.c |   36 ++++++++++++++++++++++++++++--------
>  1 files changed, 28 insertions(+), 8 deletions(-)

Keep it in my branch for testing.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
