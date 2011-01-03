Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1ACKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:13:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1ACKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:13:25 -0500
Message-ID: <4D21A141.1060801@monstr.eu>
Date: Mon, 03 Jan 2011 11:13:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] microblaze: correct PVR access macros
References: <4D1F61B9.6040900@gmail.com>
In-Reply-To: <4D1F61B9.6040900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
> A definition like:
> 
> #define PVR_IS_FULL(pvr)		(pvr.pvr[0] & PVR0_PVR_FULL_MASK)
> 
> called with PVR_IS_FULL(foo) will be preprocessed to:
> 
> (foo.foo[0] & PVR0_PVR_FULL_MASK)
>      ^^^
> So to fix this and ensure the preprocessor compiles calls correctly:
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/microblaze/include/asm/pvr.h |  160 ++++++++++++++++++------------------
>  1 files changed, 80 insertions(+), 80 deletions(-)
> 
> This was not compile tested.

Applied,

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
