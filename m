Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1AULX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 06:23:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1AULXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XtzYDGDryUXjy4HK/qWBcOjMIbcSnBjz1/JPl9lM1quAZLabgfWVc5RPXb/M8+Kv8R
         qUN9dlU+khFcaEeamnhUt1sLF7vr20VPXf6Qb2KyKx5hxDw3+z9sUfQ7cyoABxaeyYm4
         U5xksy529zjkeo676S0/8965x8mt/ZwCjqZPM=
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Hong Xu <hong.xu@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk,
        ryan@bluewatersys.com, nicolas.ferre@atmel.com
In-Reply-To: <1295332565-25610-2-git-send-email-hong.xu@atmel.com>
References: <hong.xu@atmel.com>
	 <1295332565-25610-2-git-send-email-hong.xu@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 13:23:18 +0200
Message-ID: <1295608998.3186.3.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 14:36 +0800, Hong Xu wrote:
> Some SAM9 chips have the ability to perform DMA between CPU and SMC controller.
> This patch adds DMA support for SAM9RL, SAM9G45, SSAM9G46,AM9M10, SAM9M11.
> 
> Signed-off-by: Hong Xu <hong.xu@atmel.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

