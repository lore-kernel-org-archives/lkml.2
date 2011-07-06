Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1GFG5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:57:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40016 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1GFG5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:57:11 -0400
Subject: Re: [PATCH V2] MTD: atmel_nand: optimize read/write buffer functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, hong.xu@atmel.com,
        linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de
Date: Wed, 06 Jul 2011 09:58:11 +0300
In-Reply-To: <1309789073-14593-1-git-send-email-nicolas.ferre@atmel.com>
References: <1309261856-27402-1-git-send-email-nicolas.ferre@atmel.com>
	 <1309789073-14593-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309935496.3149.73.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 16:17 +0200, Nicolas Ferre wrote:
> For PIO NAND access functions, we use the features of the SMC:
> - no need to take into account the NAND bus width: SMC will deal with this
> - use of an IO memcpy on the NAND chip-select space is able to generate
>   proper SMC behavior.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> V2: use of memcpy_fromio/memcpy_toio for proper handling of memory types.

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

