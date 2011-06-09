Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1FIJAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:00:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61488 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1FIJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:00:23 -0400
Message-ID: <4DF08B9F.10809@monstr.eu>
Date: Thu, 09 Jun 2011 11:00:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: remove duplicated prototype of start_thread()
References: <1307536205-20377-1-git-send-email-minipli@googlemail.com>
In-Reply-To: <1307536205-20377-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause wrote:
> The prototype for start_thread() is already present in the MMU/NOMMU
> independent part of the file. Remove the duplicate.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  arch/microblaze/include/asm/processor.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)

Applied.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
