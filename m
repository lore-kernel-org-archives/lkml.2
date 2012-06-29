Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2F2OUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:20:13 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:40401 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F2OUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:20:11 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjBNAAq57U9V5qg+PGdsb2JhbABFihWsQRkBAQEBHhkNJ4IYAQEEAScTHCMFCwgDDjgUJQoaiBkJvDAUkE1gA5UyhWaDQYk+
X-IronPort-AV: E=Sophos;i="4.77,498,1336341600"; 
   d="scan'208";a="365868800"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 29 Jun 2012 16:23:45 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH 00/23 v6] cleanup atmel_mxt_ts
Message-ID: <20120629142345.GA8411@polaris.bitmath.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset cleans up the atmel_mxt_ts touchscreen driver.
> 
> They were tested using an MXT224E, and apply cleanly to input/next.
> 
> Changes in v6:
>  * Patches 1-8: No change
>  * Patch 9: refactor per Henrik, and abort on error
>  * Patch 10: rebased
>  * Patch 11: kfree()
>  * Patch 12-17: rebased
>  * Patch 18: refactored per Henrik
>  * Patch 19: Moved init spew from info -> debug & refactor kfree()
>  * Patch 20, 23: refactored per Henrik
>  * Patch 21-22: rebased
>  * Patch 23: refactored per Henrik
> 
> Daniel Kurtz (23):
>   Input: atmel_mxt_ts - derive phys from i2c client adapter
>   Input: atmel_mxt_ts - use client name for irq
>   Input: atmel_mxt_ts - detect OOM when creating mt slots
>   Input: atmel_mxt_ts - warn if sysfs could not be created
>   Input: atmel_mxt_ts - don't read T5 when dumping objects
>   Input: atmel_mxt_ts - use scnprintf for object sysfs entry
>   Input: atmel_mxt_ts - optimize reading objects in object sysfs entry
>   Input: atmel_mxt_ts - print less overhead when dumping objects
>   Input: atmel_mxt_ts - print all instances when dumping objects
>   Input: atmel_mxt_ts - return errors from i2c layer
>   Input: atmel_mxt_ts - add variable length __mxt_write_reg
>   Input: atmel_mxt_ts - optimize writing of object table entries
>   Input: atmel_mxt_ts - read ID information block in one i2c
>     transaction
>   Input: atmel_mxt_ts - update driver ID info logging
>   Input: atmel_mxt_ts - add sysfs entries to read fw and hw version
>   Input: atmel_mxt_ts - simplify event reporting
>   Input: atmel_mxt_ts - add detail to touchevent debug message
>   Input: atmel_mxt_ts - refactor when and how object table is freed
>   Input: atmel_mxt_ts - cache T9 reportid range when reading object
>     table
>   Input: atmel_mxt_ts - refactor reportid checking in mxt_interrupt
>   Input: atmel_mxt_ts - use T9 reportid range to init number of mt
>     slots
>   Input: atmel_mxt_ts - send all MT-B slots in one input report
>   Input: atmel_mxt_ts - parse T6 reports
> 
>  drivers/input/touchscreen/atmel_mxt_ts.c |  468 +++++++++++++++--------------
>  1 files changed, 242 insertions(+), 226 deletions(-)
> 
> -- 
> 1.7.7.3
> 

All 23 patches applied and pushed. Thank you!

Henrik
