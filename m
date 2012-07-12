Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161500Ab2GLRsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:48:07 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:51109 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934162Ab2GLRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:48:03 -0400
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
Date: Thu, 12 Jul 2012 10:48:01 -0700
In-Reply-To: <CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
	(Linus Walleij's message of "Thu, 12 Jul 2012 13:03:00 +0200")
Message-ID: <87a9z4g9bi.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Walleij <linus.walleij@linaro.org> writes:

> On Thu, Jul 12, 2012 at 1:25 AM, Kevin Hilman <khilman@ti.com> wrote:
>
>> There is quite a bit of other things to do in remove to properly cleanup
>> what is done in probe.
>
> OK I'm dropping this patch for now...
>

Thanks.

For future reference...  as one of the OMAP maintainers, I request that
you not pull/merge OMAP GPIO patches unless they've had a bit of review
and exposure.  Unfortunately, we have a history with this driver where
regressions have been introduced and the maintainers end up having to
find and fix them.  

In the case of OMAP GPIO, unless it's an obvious fix, I would recommend
you wait at least until you see some acks/tested tags from any of

- Santosh Shilimkar <santosh.shilimkar@ti.com>
- Rajendra Nayak <rnayak@ti.com>
- Benoit Cousson <b-cousson@ti.com>

or Tony, Paul or myself.

For major series, I have been collecting/queueing them for Grant after
ensuring they have been well reviewed and well tested (although I am
eagerly hoping to hand off this role to someone else.)

Thanks,

Kevin
