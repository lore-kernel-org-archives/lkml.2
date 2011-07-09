Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1GIU7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:59:09 -0400
Received: from void.printf.net ([89.145.121.20]:59830 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GIU7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:59:07 -0400
From: Chris Ball <cjb@laptop.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mmc@vger.kernel.org, hans-christian.egtvedt@atmel.com,
        kernel@avr32linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH V3] MMC: PM: add suspend/resume in atmel-mci
References: <1309530754.4373.3.camel@hcegtvedt.norway.atmel.com>
	<1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com>
Date: Sat, 09 Jul 2011 16:58:48 -0400
In-Reply-To: <1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com>
	(Nicolas Ferre's message of "Mon, 4 Jul 2011 13:38:25 +0200")
Message-ID: <m2iprbkw6v.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 04 2011, Nicolas Ferre wrote:
> Take care of slots while going to suspend state.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> V3: take care of each slot SUSPENDED state
>     (adding a status bit in the slot "flags")
> V2: move to pm_ops

Thanks, I've merged v3 of this patch for mmc-next/3.1 with Felipe's
Reviewed-by, and your [2/2] kconfig change.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
