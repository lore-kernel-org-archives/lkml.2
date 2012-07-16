Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2GPRKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:10:49 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:34862 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753511Ab2GPRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:10:44 -0400
From: Kevin Hilman <khilman@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson\, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
Organization: Texas Instruments, Inc.
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
	<87394xhocn.fsf@ti.com>
	<CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
	<87a9z4g9bi.fsf@ti.com>
	<CACRpkdZxUpQ=a-yQ8b4bnX3S9penPWkxJ+PG2Zi4i9YZibYRiw@mail.gmail.com>
Date: Mon, 16 Jul 2012 10:10:58 -0700
In-Reply-To: <CACRpkdZxUpQ=a-yQ8b4bnX3S9penPWkxJ+PG2Zi4i9YZibYRiw@mail.gmail.com>
	(Linus Walleij's message of "Sat, 14 Jul 2012 22:51:44 +0200")
Message-ID: <87ipdnein1.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Thu, Jul 12, 2012 at 7:48 PM, Kevin Hilman <khilman@ti.com> wrote:
>
>> In the case of OMAP GPIO, unless it's an obvious fix, I would recommend
>> you wait at least until you see some acks/tested tags from any of
>>
>> - Santosh Shilimkar <santosh.shilimkar@ti.com>
>> - Rajendra Nayak <rnayak@ti.com>
>> - Benoit Cousson <b-cousson@ti.com>
>>
>> or Tony, Paul or myself.
>
> Instead of trying to store this information in my and Grants brains and
> us forgetting it, what about patching MAINTAINERS to reflect the fact
> instead? That's better I think, plus I use that file a lot.
>
>> For major series, I have been collecting/queueing them for Grant after
>> ensuring they have been well reviewed and well tested (although I am
>> eagerly hoping to hand off this role to someone else.)
>
> Listing it under your GIT tree in MAINTAINERS for this driver will make
> this work better I think.
>
> One path for OMAP GPIO patches, simple. It's obviously the
> ambiguity that cause the trouble. Then you can also decide
> on each cycle whether to send these to GPIO or ARM SoC
> etc.

Yeah, I understand the process, but I've been avoiding doing that
because, well, I don't want the job.  I have been trying to get someone
else at TI to maintain this driver, but have not been successful.

So, until that happens, feel free to queue up the patch below.

Santosh, note that I've put you as co-maintainer of this driver.

Kevin


>From c429e2e98ea7add98b85a47483ca7126284b22e6 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Mon, 16 Jul 2012 10:05:07 -0700
Subject: [PATCH] MAINTAINERS: add entry OMAP GPIO driver

Since I've been maintaining this, making it official at the request of the
GPIO maintainers.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03df1d1..61d117a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4943,6 +4943,13 @@ S:	Maintained
 F:	drivers/usb/*/*omap*
 F:	arch/arm/*omap*/usb*
 
+OMAP GPIO DRIVER
+M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Kevin Hilman <khilman@ti.com>
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/gpio/gpio.omap.c
+
 OMFS FILESYSTEM
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-karma-devel@lists.sourceforge.net
-- 
1.7.9.2

