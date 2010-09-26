Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0IZMF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 08:05:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0IZMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 08:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dXq3moX5cGk0hBu06Q8KYD0gBQnQhvuM/iaVDk6l+KZvdY105tZTPYzhGFfpEMRma9
         khh8+7X5RJ9AifZ9j1FaBbb1AqiPo0FxJjU+O2bjmggIGse58D7BpXC+4d8txWT8ny6V
         hwiTSuj8nFJ/pOX4JzQNCcwnQP4dTk+3JbU9E=
Subject: Re: [PATCH] mtd : add init_size hook for NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1285328063-7982-1-git-send-email-shijie8@gmail.com>
References: <1285328063-7982-1-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Sep 2010 15:05:19 +0300
Message-ID: <1285502719.13050.17.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 19:34 +0800, Huang Shijie wrote:
> Not all the NAND devices have all the information in additional
> id bytes.
> 
> So add a hook in the nand_chip{} is a good method to calculate the
> right value of oobsize, erasesize and so on.
> 
> Without the hook,you will get the wrong value, and you have to hack
> in the ->scan_bbt() to change the wrong value which make the code
> mess.
> 
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c |    6 ++++--
>  include/linux/mtd/nand.h     |    5 +++++
>  2 files changed, 9 insertions(+), 2 deletions(-)

Taken to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

