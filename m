Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1HODMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:12:24 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48329 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab1HODMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:12:21 -0400
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: Leo Yan <leoy@marvell.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
In-Reply-To: <1313377794-26721-1-git-send-email-leoy@marvell.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 11:11:33 +0800
Message-ID: <1313377893.14434.5.camel@Lily>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
> On mmp platform, there have two sram banks:
> audio sram bank, and internal sram bank for video and PM.
> So add the sram module to manage these sram banks.
> 
> And register the sram banks so can dynamically alloc/free
> the buffer.
> 
> Leo Yan (3):
>   ARM: mmp: add sram allocator
>   ARM: mmp: register audio sram bank
>   ARM: mmp: register internal sram bank
> 
>  arch/arm/Kconfig                      |    1 +
>  arch/arm/mach-mmp/Makefile            |    2 +-
>  arch/arm/mach-mmp/brownstone.c        |   11 ++
>  arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
>  arch/arm/mach-mmp/mmp2.c              |    3 +
>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
>  7 files changed, 232 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
>  create mode 100644 arch/arm/mach-mmp/sram.c
> 
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

