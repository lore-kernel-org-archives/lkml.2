Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1HSMGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:06:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39589 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1HSMGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:06:16 -0400
Subject: Re: [PATCH v3] drivers/mtd/nand/bcm_umi_nand.c: clean up error
 handling code
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: Jiandong Zheng <jdzheng@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>
Date: Fri, 19 Aug 2011 15:08:00 +0300
In-Reply-To: <1312964054-25266-1-git-send-email-julia@diku.dk>
References: <1312964054-25266-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313755685.6607.53.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:14 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Convert error handling code to use gotos.  At the same time, this adds
> calls to kfree and iounmap in a few cases where they were overlooked.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk> 

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

