Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab1IIJTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:19:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58899 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107Ab1IIJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:19:42 -0400
Message-ID: <4E69DA2A.8070707@monstr.eu>
Date: Fri, 09 Sep 2011 11:19:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli.billauer@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added sync method support for DMA and made refinements
 (Take II)
References: <4E60A276.7010903@billauer.co.il> <1314976538-21052-1-git-send-email-eli.billauer@gmail.com>
In-Reply-To: <1314976538-21052-1-git-send-email-eli.billauer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>

Missing description. + add "microblaze: " prefix to subject.

I have looked at the patch again and I would prefer
to separate it to 3 patches.

1. Move __dma_sync to dma-mapping.h + fix parameters.
2. Introduce new sync operations
3. The rest of changes in dma code.

I have no problem to apply patch 1 and 2.
If you show me bug you see with patch 3, I will test it and keep in my repo for a while.
As I wrote in my previous post, I am open to add your comment to dma code
that flush will be safer to use but slower if cache lines are dirty but I don't like
to cache the code without real problem.
In any case, if you show me, on program/driver/etc that the problem is in invalidation
I will apply it without no problem.

Thanks for your patches,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
