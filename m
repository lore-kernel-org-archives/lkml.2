Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1GZIbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:31:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45591 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1GZIbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:31:05 -0400
Message-ID: <33198.192.168.10.11.1311669060.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <20110722171708.370b2cf5.rdunlap@xenotime.net>
References: <20110722171708.370b2cf5.rdunlap@xenotime.net>
Date: Tue, 26 Jul 2011 14:01:00 +0530
Subject: Re: [PATCH] mfd: twl6030-pwm.c needs MODULE_LICENSE
From: Hemanth V <hemanthv@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "lkml" <linux-kernel@vger.kernel.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "akpm" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap <rdunlap@xenotime.net>
>
> twl6030_pwm: module license 'unspecified' taints kernel.
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Hemanth V <hemanthv@ti.com>

Acked-by: Hemanth V <hemanthv@ti.com>

> ---
>  drivers/mfd/twl6030-pwm.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- lnx-30-rc7.orig/drivers/mfd/twl6030-pwm.c
> +++ lnx-30-rc7/drivers/mfd/twl6030-pwm.c
> @@ -161,3 +161,5 @@ void pwm_free(struct pwm_device *pwm)
>  	kfree(pwm);
>  }
>  EXPORT_SYMBOL(pwm_free);
> +
> +MODULE_LICENSE("GPL");
>


