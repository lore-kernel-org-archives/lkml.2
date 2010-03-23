Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0CWHWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 03:22:24 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65518 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0CWHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 03:22:23 -0400
Message-ID: <4BA86C27.60101@monstr.eu>
Date: Tue, 23 Mar 2010 08:22:15 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
       hskinnemoen@atmel.com
Subject: Re: [PATCH] uImage: Allow to specify MKIMAGE
References: <20100320184907.8036.82488.stgit@localhost.localdomain>
In-Reply-To: <20100320184907.8036.82488.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulius Zaleckas wrote:
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
> ---
> 
>  arch/arm/boot/Makefile          |    4 ++--
>  arch/avr32/boot/images/Makefile |    4 ++--
>  arch/blackfin/boot/Makefile     |    4 ++--
>  arch/microblaze/boot/Makefile   |    4 ++--
>  arch/sh/boot/Makefile           |    4 ++--
>  scripts/mkuboot.sh              |    1 +
>  6 files changed, 11 insertions(+), 10 deletions(-)
> 
Acked-by: Michal Simek <monstr@monstr.eu>


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
